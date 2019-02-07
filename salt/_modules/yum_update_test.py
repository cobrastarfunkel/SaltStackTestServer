
'''
@Author: Ian Cobia
Version 1.1

Salt module that runs yum update, logs what happened, and pushes that back to the master.

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



def _yum_run():
    '''
    A private function to test running Yum updates by monitoring whether the
    command returns certain Strings.  Also testing logging feature levels

    #### TODO: Need to mess with yum repo configs to cause errors to cover possible bad outcomes

    '''
    yum_output = __salt__['cmd.run']('yum update -y', python_shell=True)

    if 'No packages' in yum_output:
        log.warning('No Packages marked for Update')
        push_file = '{}_{}_No_Packages'.format(__grains__['id'], time.strftime("%Y%m%d"))
        f = open('/tmp/{}'.format(push_file), 'w')
        f.write(yum_output)
        return (False, push_file)

    elif ('failed' in yum_output) or ('error' in yum_output) or ('errno' in yum_output):
        log.error('#### Yum Cmd Failed! ####')
        push_file = '{}_{}_FAILED'.format(__grains__['id'], time.strftime("%Y%m%d"))
        f = open('/tmp/{}'.format(push_file), 'w')
        f.write(yum_output)
        return (False, push_file)

    else:
        push_file = '{}_{}_Succeeded'.format(__grains__['id'], time.strftime("%Y%m%d"))
        f = open('/tmp/{}'.format(push_file), 'w')
        f.write(yum_output)
        return (True, push_file)



def _push_files(push_file, file_path):
       '''
       Push the files from the minions to the master cache.  They are stored in
       /var/cache/salt/master/{minion_id}/files/
       '''


       # Create Log dir if not present
       if not os.path.exists(file_path):
          _sp.call('mkdir {}'.format(file_path), shell=True)

       # Salt push command
       __salt__['cp.push']('/tmp/{}'.format(push_file), remove_source=True)



def run_updates(reboot=False):
    '''
    Runs the _yum_run module, pushes the results in a file to the master, and reboots
    if yum had a successful update and True was passed as an argument.
    No packages marked for update is not considered successful because a reboot isn't required.
    This will show in the output from Salt. Add True to the command if you want it to reboot the
    server on a successful update, it will not reboot if no packages are marked
    or an error with yum occurs even if you pass True as an argument.

    CLI Example:
    ## Default, will not reboot server
        salt "*" yum.update

    ## This command will Reboot the server
        salt "*" yum.update true

    '''

    # Path where you want the Log from the update to be stored
    update_file_path = '/home/update_minions'

    # Run the yum update and save output
    update_succeeded, push_file = _yum_run()

    # Push the files from minion to master
    _push_files(push_file, update_file_path)

    if update_succeeded:
       __salt__['event.fire_master']('{"Update":"Succeeded"}', '/update/complete')

       if reboot:
         _sp.call("reboot", shell=True)
         return ('Update Run and files pushed to master Rebooting.....')

       return (
       'Update Run and files pushed to master',
       'Log located in {} '.format(update_file_path))

    elif 'No_Packages' in push_file:
      __salt__['event.fire_master']('{"Update":"NoPacks"}', '/update/complete')

      return (
      'No Packages Marked for Update',
      'Log located in {} '.format(update_file_path))

    else:
      __salt__['event.fire_master']('{"Update":"Failed"}', '/update/complete')

      return (False, push_file)

