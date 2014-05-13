from decimal import Decimal

__author__ = 'lan'
import MySQLdb
from MySQLdb import cursors
from datetime import datetime, timedelta


class Billing():
    def __init__(self, user, pwd, db):
        self.db = MySQLdb.connect(user=user, passwd=pwd, db=db)
        self.c = self.db.cursor(cursors.DictCursor)

    def get_orders(self, user_id):
        self.c.execute("select OrderId from orders where UserId = %s and VmStatus <> 'T'", user_id)
        orders = []
        for row in self.c.fetchall():
            orders.append(row['OrderId'])
        return orders

    def calc_bill_by_user(self, user_id):
        report = []
        total = 0.0
        valid_orders = self.get_orders(user_id)
        if len(valid_orders) == 0:
            return [{'total': 0.00}]

        for order_id in valid_orders:
            bill = self.calc_bill_by_id(order_id)
            report.append(bill)
            total += bill["fee"]

        report.append({'total pending': total})
        return report

    def calc_bill_by_id(self, order_id):
        """
        calculate bill for one order
        """
        self.c.execute("select RatePlan, UnitPrice, Uptime, LastStartTime, VmStatus, VmId, LastBillDate, UserId from orders where OrderId = %s", order_id)
        order = self.c.fetchone()
        uptime = order['Uptime']
        now = datetime.now()
        if order['VmStatus'] == 'A':
            begin = max(order['LastStartTime'], order['LastBillDate'])
            uptime += (now - begin).seconds

        if order['RatePlan'] == 0: # on-demand
            fee = round(float(order['UnitPrice']) * uptime / 60, 2)
        elif order['RatePlan'] == 1: # flat rate
            fee = float(order['UnitPrice'])

        return {'order_id':order_id, 'user_id': int(order['UserId']),'from': str(order['LastBillDate']),
                'to': now.isoformat(' ').split('.')[0], 'plan':int(order['RatePlan']),
                'unit price': float(order['UnitPrice']), 'uptime': int(uptime), 'fee':fee}

    def generate_report_by_id(self, order_id):
        """
        generate reports for one order
        """
        bill = self.calc_bill_by_id(order_id)
        due = datetime.now() + timedelta(days=20)
        self.c.execute("insert into billing(OrderId, UserId, StartTime, EndTime, Plan, UnitPrice, Uptime, Charge, DueDate, Status) "+\
                       "values (%s, %s, '%s', '%s', %s, %s, %s, %s, '%s', 'A')" % \
                       (bill['order_id'], bill['user_id'], bill['from'], bill['to'], bill['plan'], bill['unit price'], bill['uptime'], bill['fee'], due))
        self.c.execute("update orders set Uptime = 0, LastBillDate = %s where OrderId = %s", (bill['to'], bill['order_id']))
        self.db.commit()

    def generate_reports(self):
        """
        generate reports for all orders
        """
        self.c.execute("select OrderId from orders where VmStatus <> 'T'")
        for row in self.c.fetchall():
            self.generate_report_by_id(int(row['OrderId']))

    def get_bill_history(self, user_id):
        """
        get billing history by user id
        """
        self.c.execute("select * from billing where UserId = %s", user_id)
        bills = []
        total = 0.0
        for row in self.c.fetchall():
            bill = {'order_id':row['OrderId'], 'user_id': row['UserId'],'from': str(row['StartTime']),
                    'to': str(row['EndTime']), 'plan': row['Plan'], 'unit price': float(row['UnitPrice']),
                    'uptime':row['Uptime'], 'fee': float(row['Charge']), 'status':row['Status']}
            bills.append(bill)
            if bill['status'] == 'A':
                total += bill['fee']

        bills.append({'total unpaid': total})
        return bills

    def get_paid_bill_detail(self, user_id, paid_date):
        if paid_date == '---':
            self.c.execute("select b.BillId, o.VmName, b.Plan, b.UnitPrice, round(b.Uptime/60,1) Uptime, b.Charge from billing as b inner join orders as o on b.OrderId = o.OrderId where b.UserId = %s and b.Status='A'", user_id)
        else:
            self.c.execute("select b.BillId, o.VmName, b.Plan, b.UnitPrice, round(b.Uptime/60,1) Uptime, b.Charge from billing as b inner join orders as o on b.OrderId = o.OrderId where b.UserId = %s and b.PaidDate=%s", (user_id, paid_date))

        sub_items = self.c.fetchall()
        total = 0.0
        for item in sub_items:
            total += float(item['Charge'])

        tax = 0.00

        now = datetime.now()

        bill_detail = {'SubItems': sub_items, 'Subtotal': round(total, 2),
                       'Tax': round(tax, 2), 'Total': round(total+tax, 2),
                       'Date': (now.strftime("%B %d, %Y") if paid_date == '---' else datetime.strptime(paid_date, '%Y-%m-%d %H:%M:%S').strftime("%B %d, %Y")),
                       'IsPaid': (paid_date != '---')}
        return bill_detail

    def pay_bill(self, bill_ids):
        format_strings = ','.join(['%s'] * len(bill_ids))
        params = []
        params.append(datetime.now())
        params.extend(bill_ids)
        self.c.execute("update billing set Status='C', PaidDate=%s where BillId in (" + format_strings + ")", tuple(params))
        self.db.commit()

    def get_bills_by_user(self, user_id):
        """
        return bills by user id
        """
        self.c.execute("select @rn:= @rn+1 No, sum(Charge) Amount, Status!='A' IsPaid, PaidDate from billing , (SELECT @rn:=0 rn) as n where UserId = %s group by PaidDate order by rn desc", user_id)
        result = self.c.fetchall()
        self.db.commit()
        return result

    def get_active_bill_by_user(self, user_id):
        self.c.execute("select IFNULL(round(sum(Charge),2),0.00) amount from billing where Status = 'A' and UserId = %s", user_id)
        return self.c.fetchone()

    def get_hourly_usage_by_user(self, user_id):
        """
        return hourly usage by user id
        """
        self.c.execute("select DATE_FORMAT(EndTime,'%%Y-%%m-%%d %%h:00:00') Date, FORMAT(Uptime/60,0) Uptime from logs where VmId in (select VmId from instance where ReservedBy = %s)  group by Date", user_id)

        return self.c.fetchall()

    def get_hourly_cost_by_user(self, user_id):
        """
        return hourly cost by user id
        """
        self.c.execute("select DATE_FORMAT(EndTime,'%%Y-%%m-%%d %%h:00:00') Date, FORMAT(sum(Charge),2) Amount from billing where UserId = %s  group by Date", user_id)
        return self.c.fetchall()
