
move_update_files:
  runner.move_updates.pull


#move_update_files:
 # local.cmd.run:
  #  - tgt: 'id:salt-master'
   # - tgt_type: grain
    #- arg:
     # - cp /var/cache/salt/master/minions/{{ data['id'] }}/files/tmp/* /tmp/updated_minions/
