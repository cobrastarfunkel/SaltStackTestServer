
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
    'run_updates': 'update',
    'push_files': 'push',
}

# Salt module can be called by this name
__virtualname__ = 'yum'



def __virtual__():
    '''
    Check if OS is RHEL or not.
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
        push_file = '{}_{}_No_Packages'.format(__grains__['id'], time.strftime("%Y%m%d"))
        f = open(push_file, 'w')
        f.write(yum_output)
        return (False, push_file)
    
    elif ('failed' in yum_output) or ('error' in yum_output) or ('errno' in yum_output):
        log.error('#### Yum Cmd Failed! ####')
        push_file = '{}_{}_FAILED'.format(__grains__['id'], time.strftime("%Y%m%d"))
        f = open(push_file, 'w')
        f.write(yum_output)
        return (False, push_file)
    
    else:
        push_file = '{}_{}_Succeeded'.format(__grains__['id'], time.strftime("%Y%m%d"))
        f = open(push_file, 'w')
        f.write(yum_output)
        return (True, push_file)



def push_files(push_file, file_path):
       __salt__['cp.push']('/tmp/{}'.format(push_file), remove_source=True)
       
       # Move the files from salt cache
       _sp.call(
       'find /var/cache/salt/master/ -name \'%s\' -exec mv -t %s {} +' 
       % (push_file, file_path), shell=True)



def run_updates():
    '''
    Run _yum_test module, push the results in a file to the maater, and reboot
    if yum had a successful update.  No packages marked for update is not
    considered successful because a reboot isn't required.  This will show in
    the output from Salt.
    
    CLI Example:
        salt "*" yum.update
    '''

    # Path where you want the Log from the update to be stored
    update_file_path = '/home/update_minions'


    if not os.path.exists(update_file_path):
        _sp.call('mkdir {}'.format(update_file_path), shell=True)

    # Run the yum update and save output
    update_succeeded, push_file = _yum_test()
    
    # Push the files from minion to master
    push_files(push_file, update_file_path)

    if update_succeeded:
       __salt__['event.fire_master']('{"Update":"Succeeded"}', '/update/complete')
       # TODO: _sp.call("reboot", shell=True)
       return (
       'Update Run and files pushed to master Rebooting.....', 
       'Log located in {} '.format(update_file_path))

    elif 'No_Packages' in push_file:
      __salt__['event.fire_master']('{"Update":"NoPacks"}', '/update/nopacks')
      return (
      'No Packages Marked for Update', 
      'Log located in {} '.format(update_file_path))

    else:
      __salt__['event.fire_master']('{"Update":"Failed"}', '/update/complete')
      return (False, 'Check Minion Log or {} for update Error'.format(update_file_path))

