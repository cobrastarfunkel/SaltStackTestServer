{% from "linuxBaseline/vim/map.jinja" import vim with context %}

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

