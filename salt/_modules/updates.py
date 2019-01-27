

'''
@Author Ian Cobia
Version 1.0

Salt module to handle different linux family updates

### Initial Testing, this should call the specific module based on OS Family ###

'''

import __future__
import salt.utils
import salt.loader
import salt.config
import logging
import subprocess as _sp


# Allows Logging
log = logging.getLogger(__name__)

# Access to minion grains
__opts__ = salt.config.minion_config('/etc/salt/minion')
__grains__ = salt.loader.grains(__opts__)

__func_alias__ = {
    'update_servers' : 'updates'
}

__virtualname__ = 'linuxUpdates'



def __virtual__():
    if __grains__['kernel'] != 'Linux':
        return False
    return __virtualname__



def update_servers(reboot=False):
    '''
    Runs update for Debian and RedHat based systems.

    CLI Example:
        salt "*" linuxUpdates.updates
    '''

    if __grains__['os_family'] == 'RedHat':
        return __salt__['yum.update'](reboot)

    elif __grains__['os_family'] == 'Debian':
        return (True, "Debian Server")
