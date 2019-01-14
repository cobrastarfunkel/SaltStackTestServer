import __future__
import salt.utils
import salt.loader
import salt.config
import logging
import subprocess as _sp
import time

# Allows logging to be used
log = logging.getLogger(__name__)

# Access minion grains by loading minion config
__opts__ = salt.config.minion_config('/etc/salt/minion')
__grains__ = salt.loader.grains(__opts__)

# Alias for the run_updates module
__func_alias__ = {
    'run_updates': 'yum'
}

# Salt module can be called by this name
__virtualname__ = 'yumtest'



def __virtual__():
    '''
    Check if OS is RHEL or not.

    #### TODO: Read up on __virtual__ and find out how to use it for multiple OS's
    #### Possibly just make seperate modules and have this module call the appropriate one based 
    #### on OS grain.  Probably the better idea

    '''
    if __grains__['os_family'] != 'RedHat':
        return False 
    return __virtualname__



def _yum_test():
    '''
    A private function to test running Yum updates by monitoring whether the 
    command returns certain Strings.  Also testing logging feature levels

    #### TODO: Need to mess with yum repo configs to cause errors to cover possible bad outcomes

    '''
    yum_output = __salt__['cmd.run']('yum update -y', python_shell=True)

    if 'No packages' in yum_output:
        log.warning('No Packages marked for Update')
        push_file = "/tmp/" +  __grains__['id'] + "_" + time.strftime("%Y%m%d") + "_" + "No_packages"
        f = open(push_file, "w")
        f.write(yum_output)
        return (True, push_file)
    
    if 'failed' in yum_output:
        log.error('#### Yum Cmd Failed! ####')
        push_file = "/tmp/updated_minions/" + __grains__['id'] + "_" + time.strftime("%Y%m%d") + "_" + "FAILED"
        f = open(push_file, "w")
        f.write(yum_output)
        return (False, push_file)
    
    else:
        push_file = "/tmp/updated_minions/" + __grains__['id'] + "_" + time.strftime("%Y%m%d") + "_" + "Succeeded"
        f = open(push_file, "w")
        f.write(yum_output)
        return (True, push_file)


def run_updates():
    '''
    Run _yum_test module, if outcome is positive write the date to a file.
    
    #### TODO: CHANGE to Reboot if successful after testing is done
    
    CLI Example:
        salt "*" yumtest.yum
    '''
    update_succeeded, push_file = _yum_test()

    if update_succeeded:
       __salt__['cp.push'](push_file, remove_source=True)
       return (True, "Update Run and files pushed to master")

    else:
      __salt__['cp.push'](push_file, remove_source=True)
      return (False, "Check Minion Log for update Error")
