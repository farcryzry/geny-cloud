__author__ = 'lan'
import MySQLdb
import datetime
import threading
from MySQLdb import cursors
from host import Host
from billing import Billing
from time import sleep


class Controller:
    def __init__(self, user, pwd, db):
        self.user_name = user
        self.db_name = db
        self.password = pwd
        self.db = MySQLdb.connect(user=user, passwd=pwd, db=db)
        self.c = self.db.cursor(cursors.DictCursor)

    def add_instances(self, host):
        for vm_name in host.get_instances().iterkeys():
            self.c.execute("insert into instance(VmName, Host) values (%s, %s)", (vm_name, host.get_host()))
            self.db.commit()

    def get_instance_category(self):
        """
        return instance category with distinct vm_name
        """
        self.c.execute("select distinct VmName from instance")
        category = []
        for row in self.c.fetchall():
            category.append(row['VmName'])
        return category

    def get_instance_by_user(self, user_id):
        """
        return instances reserved by user id
        """
        self.c.execute("select VmId, VmName, Host from instance where ReservedBy = %s", user_id)
        return self.c.fetchall()

    def get_instance_by_uid(self, user_id):
        """
        return instances reserved by user id
        """
        self.c.execute("select *  from orders where VmStatus <> 'T' ")
        return self.c.fetchall()

    def get_idle_instances(self, vm_name):
        """
        return a list of unreserved instances by vm_name
        """
        self.c.execute("select VmId, VmName, Host from instance where VmName = %s and ReservedBy is NULL", vm_name)
        return self.c.fetchall()

    def get_host(self, host_string):
        self.c.execute("select * from host where Host = %s", host_string)
        result = self.c.fetchone()
        return Host(result['Host'], result['Key'], result['Player'])

    def get_instance_by_id(self, vm_id):
        self.c.execute("select VmId, VmName, Host from instance where VmId = %s", vm_id)
        return self.c.fetchone()

    # on-demond: plan = 0, rate = $0.1, flat-rate: plan = $1, rate = 10/per mon;
    def order_instance(self, vm, user_id, plan, rate):
        """
        given (vm_id, vm_name, host_string) and user id, launch instance
        """
        now = datetime.datetime.now().isoformat()
        sql = "insert into orders(UserId, VmId, VmName, VmStatus, Uptime, LastStartTime, RatePlan, UnitPrice, LastBillDate) "+ \
               "values (%s, %s, '%s', '%s', %s, '%s', %s, %s, '%s')" % \
                (user_id, vm['VmId'], vm['VmName'], 'S', 0, now, plan, rate, now)
        self.c.execute(sql)
        self.db.commit()
        order_id = self.c.lastrowid

        self.c.execute("update instance set ReservedBy = %s, OrderId = %s where VmId = %s", (user_id, order_id, vm['VmId']))
        self.db.commit()

        self.launch_instance(vm['VmId'])


    def launch_instance(self, vm_id):
        """
        power on vm and create a new log
        """
        vm = self.get_instance_by_id(vm_id)
        h = self.get_host(vm['Host'])
        vm_name = vm['VmName']
        thread = threading.Thread(target=Host.launch, args=(h, vm_name))
        thread.start()
        now = datetime.datetime.now()

        status = h.get_instance_status(vm_name)
        i = 0
        while status != "running" and i < 10:
            print "Check status:" + status
            print "Launch in process..."
            sleep(3)
            i += 1
            status = h.get_instance_status(vm_name)

        if status == "running":
            self.c.execute("select OrderId from instance where VmId = %s", vm_id)
            order_id = self.c.fetchone()['OrderId']
            self.c.execute("update orders set LastStartTime = %s, VmStatus = 'A' where VmId = %s and VmStatus = 'S'", (now, vm_id))
            self.c.execute("insert into logs(VmId, OrderId, StartTime, EndTime, Uptime) values (%s, %s, %s, null, null)", (vm_id, order_id, now))
            self.db.commit()
            print vm_name + " is running ", vm_id
            return True
        else:
            print vm_name + "  launch failure ", vm_id
            return False

    def poweroff_instance(self, vm_id):
        """
        power off vm and update the log
        """
        vm = self.get_instance_by_id(vm_id)
        h = self.get_host(vm['Host'])
        vm_name = vm['VmName']
        h.poweroff(vm_name)
        now = datetime.datetime.now()

        status = h.get_instance_status(vm_name)
        i = 0
        while status != "powered off" and i < 10:
            print "Check status:" + status
            print "Power off in process..."
            sleep(3)
            i += 1
            status = h.get_instance_status(vm_name)

        if status == "powered off":
            self.c.execute("select Uptime, LastStartTime, LastBillDate from orders where VmId = %s and VmStatus = 'A'", vm_id)
            timestamp = self.c.fetchone()

            diff = (now - timestamp['LastStartTime']).seconds
            self.c.execute("update logs set EndTime = %s, Uptime = %s where VmId = %s and EndTime is NULL", (now, diff, vm_id))

            if timestamp['LastStartTime'] < timestamp['LastBillDate']:
                diff = (now - timestamp['LastBillDate']).seconds
            uptime = timestamp['Uptime'] + diff
            self.c.execute("update orders set Uptime = %s, VmStatus = 'S' where VmId = %s and VmStatus = 'A'", (uptime, vm_id))

            self.db.commit()
            print vm_name + " is powered off ", vm_id
            return True
        else:
            print vm_name + "  powered off failure ", vm_id
            return False

    def terminate_instance(self, vm_id):
        """
        generate the final bill for this order and power off the instance
        """
        if self.get_instance_status(vm_id) == "powered off" or self.poweroff_instance(vm_id):
            self.c.execute("select OrderId from orders where VmId = %s and VmStatus = 'S'", vm_id)
            order_id = int(self.c.fetchone()['OrderId'])
            Billing(self.user_name, self.password, self.db_name).generate_report_by_id(order_id)

            self.c.execute("update orders set VmStatus = 'T' where OrderId = %s", order_id)
            self.c.execute("update instance set ReservedBy = null, OrderId = null where VmId = %s", vm_id)
            self.db.commit()
            return True
        else:
            return False

    def get_instance_status(self, vm_id):
        """
        return instance status: "running" or "powered off"
        """
        vm = self.get_instance_by_id(vm_id)
        self.c.execute("select VmStatus from orders where OrderId = (select OrderId from instance where VmId = %s)", vm_id)
        return "running" if self.c.fetchone()['VmStatus'] == 'A' else "powered off"

    def get_log_by_user(self, user_id):
        self.c.execute("select t.*, i.VMName from (select 'Power On' Event, VMId, StartTime Time from logs union select 'Power Off' Event, VMId, EndTime Time from logs) t inner join instance i on t.VMId = i.VMId where i.VMId in (select VMId from instance where ReservedBy = %s) order by t.Time desc", user_id)
        events = self.c.fetchall()

        return events

    def sign_up(self, email, password):
        """
        create a new user
        """
        self.c.execute("insert into user(email,password) values(%s, %s)", (email, password))
        self.db.commit()
        return self.c.lastrowid

    def sign_in(self, email, password):
        """
        user sign in
        """
        result = self.c.execute("select UserId from user where email = %s and password = %s", (email, password))

        if result:
            return self.c.fetchone()['UserId']
        else:
            return 0

    def user_update(self, uid, password):        
        """
        update user information(password)
        """
        self.c.execute("update user set password = '%s' where uid = %s",(password,uid))
        self.db.commit()



