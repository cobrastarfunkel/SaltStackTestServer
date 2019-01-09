
reactor_test:
  local.cmd.run:
    - tgt: {{ data['id'] }}
    - arg:
      - echo $(date) " Reactor" >> /tmp/reactTest.txt


react_to_reactor_test:
  local.state.apply:
    - tgt: {{ data['id'] }}
    - arg:
      - post_react_test
    - require:
      - cmd: reactor_test
