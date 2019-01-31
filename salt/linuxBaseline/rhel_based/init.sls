

/etc/vimrc:
  file.managed:
    - source: salt://{{ tpldir }}/files/vimrc
    - mode:   644
