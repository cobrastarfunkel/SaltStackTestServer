{% from "linuxBaseline/vim/map.jinja" import vim with context %}

yum_repos:
  file.recurse:
    - name:   /etc/yum.repos.d
    - source: salt://{{ tpldir }}/files/yum.repos.d
    - clean: true

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

