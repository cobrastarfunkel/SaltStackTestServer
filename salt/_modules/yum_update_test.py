import __future__
import salt.utils
import logging
import subprocess as _sp

# Allows logging to be used
log = logging.getLogger(__name__)

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
    file_name_by_date = _sp.call("$(date)", shell=True) #### Fix Me ####
    f = open("/tmp/%sYum_update.txt" % file_name_by_date, "a")

    if 'No packages' in yum_output:
        log.warning('No Packages marked for Update')
        f.write(yum_output)
        return (False, yum_output)
    
    if 'failed' in yum_output:
        log.error('#### Yum Cmd Failed! ####')
        f.write(yum_output)
        return (False, yum_output)
    
    else:
        f.write(yum_output)
        return (True, 'Yum Update Suceeded')


def run_updates():
    '''
    Run _yum_test module, if outcome is positive write the date to a file.
    
    #### TODO: CHANGE to Reboot if successful after testing is done
    
    CLI Example:
        salt "*" yumtest.yum
    '''
    if _yum_test():
       _sp.call("echo $(date) >> /tmp/yum_test.txt", shell=True)

    else:
      return (False, "Check Minion Log for update Error")
