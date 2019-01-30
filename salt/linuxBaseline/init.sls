include:
  - {{ tpldir }}.firewall

/etc/screenrc:
  file.managed:
    - source:     salt://{{ tpldir }}/files/screenrc
    - mode:       644
