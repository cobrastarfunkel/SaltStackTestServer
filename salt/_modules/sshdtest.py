import __future__
import salt.utils
import logging

log = logging.getLogger(__name__)

__func_alias__ = {
    'yum_test': 'yum'
}



__virtualname__ = 'sshdtest'

def __virtual__():
    if __grains__['os_family'] != 'RedHat':
        return False
    return __virtualname__



def yum_test():
    yum_output = __salt__['cmd.run']('yum update -y', python_shell=True)
    if 'No packages' in yum_output:
        log.warning('No Packages marked for Update')
        return (False, 'No Packages Marked for Update')
    if 'failed' in yum_output:
        log.error('#### Yum Cmd Failed! ####')
        return (False, 'Yum Update Failed')
    else:
        return (True, 'Yum Update Suceeded')
