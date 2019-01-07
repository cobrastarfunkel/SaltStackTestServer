
vim_installed:
  pkg.installed:
    - name: vim

pre_react:
  cmd.run:
    - name: echo $(date) " Pre React" >> /tmp/reactTest.txt
    - require: 
      - vim_installed
    - fire_event: vim/installed

python-pip:
    pkg.installed

requests:
    pip.installed:
      - require:
        - pkg: python-pip

/tmp/test.txt:
  file.managed:
    - source: salt://test.txt
