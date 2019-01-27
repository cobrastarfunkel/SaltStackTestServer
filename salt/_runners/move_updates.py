import __future__
import salt.utils
import salt.loader
import salt.config
import salt.client
import logging
import subprocess as _sp
import os.path

__func_alias__ = {
    'pull_updates' : 'pull',
}


def pull_updates(file_path='/home/update_minions/'):
   
    if not os.path.exists(file_path):
        return (False, "File Path not Found!")

    ret_minions = ''
    client = salt.client.LocalClient(__opts__['conf_file'])
    minions = client.cmd('*', 'test.ping', timeout=1)

    for minion in sorted(minions):
      _sp.call(
      'find /var/cache/salt/master/minions/%s/files/tmp/ -name \'%s*\' -exec mv -t %s {} +'
      % (minion, minion, file_path), shell=True) 

      ret_minions += "{}\n".format(minion)
    
    return (True, ret_minions, 'Files stored in {}'.format(file_path))
