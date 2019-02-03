{% from "linuxBaseline/vim/map.jinja" import vim with context %}

include:
  - {{ tpldir }}.firewall
  - {{ tpldir }}.vim

{#
{% set vim_pkg = {
    'RedHat': 'vim-enhanced',
    'Debian': 'vim',
}.get(grains.os_family) %}
#}

standardPackages:
  pkg.installed:
    - pkgs:
      - {{ vim.pkg }}
      - git
      - screen
      - mlocate

# screen config
/etc/screenrc:
  file.managed:
    - source:     salt://{{ tpldir }}/files/screenrc
    - mode:       644

