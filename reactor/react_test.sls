reactor_test:
  local.cmd.run:
    - tgt: {{ data['id'] }}
    - arg:
      - echo $(date) " Reactor" >> /tmp/reactTest.txt
