{% from "linuxBaseline/vim/map.jinja" import vim with context %}

vimrc_configs:
  file.managed:
    - name: {{ vim.vimrc_path }}
    - mode : 644
    - source: salt://{{ tpldir }}/files/{{ vim.vimrc }}

# Adds Vundle to Home dir for users
vundle_install:
  cmd.script:
    - name: salt://{{ tpldir }}/files/userId.sh
    - cwd: /run

install_vundle_plugins:
  cmd.run:
    - name: vim -c 'PluginInstall' -c 'qa!'
    - require:
      - vundle_install
