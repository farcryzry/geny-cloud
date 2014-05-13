__author__ = 'lan'
from fabric.api import run, env, hide, settings


class Host:
    def __init__(self, host, key_path, player_path):
        env.hosts = [host]
        env.key_filename = key_path
        env.port = 22
        env.host_string = host
        self.player_path = player_path

    def get_host(self):
        return env.host_string

    def exe_cmd(self, cmd):
        with hide('output','running','warnings'), settings(warn_only=True):
            try:
                print "[Execute remote command]", cmd
                return run(cmd)
            except Exception, e:
                print " Caught exception: ", e.message
                return self.exe_cmd(cmd)

    def launch(self, vm_name):
        self.exe_cmd(self.player_path + ' --vm-name "' + vm_name + '"')

    def poweroff(self, vm_name):
        self.exe_cmd("VBoxManage controlvm '"+ vm_name +"' poweroff")
        self.exe_cmd('ps -axf | grep "' + self.player_path + ' --vm-name ' + vm_name + '" | grep -v grep | awk \'{print "kill " $2}\' | sh')

    def get_instances(self):
        try:
            lists = self.exe_cmd("VBoxManage list vms -l | grep -e ^Name -e ^State | sed s/\ \ //g | cut -d: -f2-").split('\r\n')
            if len(lists) == 0 or len(lists)%2 != 0:
                raise Exception(lists)
            instances = {}
            for i in range(0, len(lists), 2):
                instances[lists[i]] = lists[i+1][1:]

            return instances
        except Exception, e:
            print "Get instances exception:", e.message
            return self.get_instances()

    def get_instance_status(self, vm_name):
        status = self.get_instances()[vm_name]
        return status.split('(')[0][:-1]

    def get_running_instances(self):
        lists = self.exe_cmd("VBoxManage list runningvms").split('\n')
        instances = []
        for instance in lists:
            instances.append(instance.split('"')[1])
        return instances

    def get_poweroff_instances(self):
        instances = []
        for vm_name, status in self.get_instances().items():
            if status.split('(')[0][:-1] == 'powered off':
                instances.append(vm_name)
        return instances

