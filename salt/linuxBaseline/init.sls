{% from "linuxBaseline/vim/map.jinja" import vim with context %}

include:
  - {{ tpldir }}.firewall
  - {{ tpldir }}.packages
  - {{ tpldir }}.vim
  
