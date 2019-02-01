
{% set name = {
    'CentOS' : '/etc/vimrc',
    'Raspbian' : '/etc/vim/vimrc',
}.get(grains.os) %}

{% set vimrc = {
    'CentOS' : 'vimrc_Cent',
    'Raspbian' : 'vimrc_Rasp',
}.get(grains.os) %}

vimrc_configs:
  file.managed:
    - name: {{ name }}
    - mode : 644
    - source: salt://{{ tpldir }}/files/{{ vimrc }}

# Adds Vundle to Home dir for users
vundle_install:
  cmd.script:
    - name: salt://{{ tpldir }}/files/userId.sh
    - cwd: /run
