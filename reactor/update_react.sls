

move_update_files:
  local.cmd.run:
    - tgt: 'id:salt-master'
    - tgt_type: grain
    - arg:
      - mkdir /tmp/updated_minions && mv /var/cache/salt/master/minions/{{ data['id'] }}/files/tmp/* /tmp/updated_minions/
