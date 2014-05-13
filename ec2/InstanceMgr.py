__author__ = 'lan'
import boto.ec2
import csv


class InstanceMgr:

    def __init__(self, credential_file_path):
        with open(credential_file_path, 'rb') as csvfile:
            reader = csv.DictReader(csvfile, delimiter=',')
            account = reader.next()
            access_key = account.get("Access Key Id")
            secret_key = account.get("Secret Access Key")

        self.conn = boto.ec2.connect_to_region("us-west-1",
                aws_access_key_id=access_key,
                aws_secret_access_key=secret_key)

    def create_instance(self, image='ami-660c3023', key_name='linuxonEC2', instance_type='t1.micro', security_groups=['default']):
        """
        create one instance with given parameters
        """
        return self.conn.run_instances(image,
                    key_name=key_name,
                    instance_type=instance_type,
                    security_groups=security_groups).instances[0]

    def get_all_instances(self):
        return self.conn.get_only_instances()

    def stop_instances(self, ids):
        """
        shutdown given list of instances
        """
        self.conn.stop_instances(instance_ids=ids)

    def start_instances(self, ids):
        """
        start given list of instances
        """
        self.conn.start_instances(instance_ids=ids)

    def reboot_instances(self, ids):
        """
        reboot given list of instances
        """
        self.conn.reboot_instances(instance_ids=ids)

    def terminate_instances(self, ids):
        """
        terminate given list of instances
        """
        self.conn.terminate_instances(instance_ids=ids)


#test
mgr = InstanceMgr('/Users/path/aws_credentials.csv')
#mgr.create_instance(security_groups=['launch-wizard-3'])
for ins in mgr.get_all_instances():
    print 'id: ' + ins.id
    print 'image id: ' + ins.image_id
    print 'instance type: ' + ins.instance_type
    print 'instance state: ' + ins.state
    if ins.state == 'running':
        mgr.stop_instances([ins.id])
#    if ins.state == 'stopped':
#        mgr.start_instances([ins.id])
#    mgr.terminate_instances([ins.id])
