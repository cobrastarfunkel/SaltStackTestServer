

# cmd.run example for Reactor
reactor_test:
  local.cmd.run:
    - tgt: 'id:salt-master'
    - tgt_type: grain
    - arg:
      - echo $(date) " Reactor" >> /tmp/reactTest.txt

# state example for Reactor
react_to_reactor_test:
  local.state.apply:
    - tgt: 'id:salt-master'
    - tgt_type: grain
    - arg:
      - post_react_test
    - require:
      - cmd: reactor_test

# cmd.script Example for Reactor
script_cmd_test:
  local.cmd.script:
    - tgt: 'id:salt-master'
    - tgt_type: grain
    - arg:
      - salt://scripts/script_tester.sh
    - require:
      - sls: react_to_reactor_test
