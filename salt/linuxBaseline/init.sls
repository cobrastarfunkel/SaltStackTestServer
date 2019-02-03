{% from "linuxBaseline/vim/map.jinja" import vim with context %}

include:
  - {{ tpldir }}.firewall
  - {{ tpldir }}.vim

standardPackages:
  pkg.installed:
    - pkgs:
      - {{ vim.pkg }}
      - git
      - screen
      - mlocate
    - require_in:
      - sls: {{ tpldir }}.vim

# screen config
/etc/screenrc:
  file.managed:
    - source:     salt://{{ tpldir }}/files/screenrc
    - mode:       644

