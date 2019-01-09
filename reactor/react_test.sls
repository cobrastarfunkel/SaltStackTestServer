

reactor_test:
  local.cmd.run:
    - tgt: 'id:salt-master'
    - tgt_type: grain
    - arg:
      - echo $(date) " Reactor" >> /tmp/reactTest.txt


react_to_reactor_test:
  local.state.apply:
    - tgt: 'id:salt-master'
    - tgt_type: grain
    - arg:
      - post_react_test
    - require:
      - cmd: reactor_test
