
'''
@Author: Ian Cobia
Version 1.0

Salt module that runs yum update, logs what happened, and pushes that back to the master.

TODO: Add reboot to a successful update
'''

import __future__
import salt.utils
import salt.loader
import salt.config
import logging
import subprocess as _sp
import os.path
import time

# Allows logging to be used
log = logging.getLogger(__name__)

# Access minion grains by loading minion config
__opts__ = salt.config.minion_config('/etc/salt/minion')
__grains__ = salt.loader.grains(__opts__)

# Alias for the run_updates module
__func_alias__ = {
    'run_updates': 'update'
}

# Salt module can be called by this name
__virtualname__ = 'yum'



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
        push_file = '/tmp/{}_{}_No_Packages'.format(__grains__['id'], time.strftime("%Y%m%d"))
        f = open(push_file, 'w')
        f.write(yum_output)
        return (False, push_file)
    
    elif ('failed' in yum_output) or ('error' in yum_output) or ('errno' in yum_output):
        log.error('#### Yum Cmd Failed! ####')
        push_file = '/tmp/{}_{}_FAILED'.format(__grains__['id'], time.strftime("%Y%m%d"))
        f = open(push_file, 'w')
        f.write(yum_output)
        return (False, push_file)
    
    else:
        push_file = '/tmp/{}_{}_Succeeded'.format(__grains__['id'], time.strftime("%Y%m%d"))
        f = open(push_file, 'w')
        f.write(yum_output)
        return (True, push_file)


def run_updates():
    '''
    Run _yum_test module, push the results in a file to the maater, and reboot
    if yum had a successful update.  No packages marked for update is not
    considered successful because a reboot isn't required.  This will show in
    the output from Salt.
    
    CLI Example:
        salt "*" yum.update
    '''
    if not os.path.exists('/tmp/updated_minions'):
        _sp.call('mkdir /tmp/updated_minions', shell=True)

    update_succeeded, push_file = _yum_test()

    if update_succeeded:
       __salt__['cp.push'](push_file, remove_source=True)
       __salt__['event.fire_master']('{"Update":"Succeeded"}', '/update/complete')
       # TODO: _sp.call("reboot", shell=True)
       return (True, 'Update Run and files pushed to master Rebooting.....')

    elif 'No_Packages' in push_file:
      __salt__['cp.push'](push_file, remove_source=True)
      __salt__['event.fire_master']('{"Update":"Succeeded"}', '/update/complete')
      return (True, 'No Packages Marked for Update')

    else:
      __salt__['cp.push'](push_file, remove_source=True)
      __salt__['event.fire_master']('{"Update":"Failed"}', '/update/complete')
      return (False, 'Check Minion Log or /tmp/updated_minions/ for update Error')

