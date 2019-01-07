import __future__
import salt.utils
import logging

log = logging.getLogger(__name__)

__func_alias__ = {
    'output_test': 'optest'
}



__virtualname__ = 'sshdtest'

def __virtual__():
    if __grains__['os_family'] != 'RedHat':
        return False
    return __virtualname__

def output_test():
    output = __salt__['cmd.run']('netstat -tulpn | grep mysql', python_shell=True)
    if 'tcp' not in output:
        log.error('MySql not found')
        return (False, 'MySql not running!')
    username = __opts__['username']
    log.info('MYSql running here\'s a Log!')
    log.warning('Here\'s a Warning')
    return (True, 'Username: ' + str(username))



def _yum_test():
    yum_output = __salt__['cmd.run']('yum update -y', python_shell=True)
    if 'No packages' in yum_output:
        log.warning('No Packages marked for Update')
        return (False, 'No Packages Marked for Update')
    if 'failed' in yum_output:
        log.error('#### Yum Cmd Failed! ####')
        return (False, 'Yum Update Failed')
    else:
        return (True, 'Yum Update Suceeded')
