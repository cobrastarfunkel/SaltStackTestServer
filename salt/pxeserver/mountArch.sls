

/mnt/arch:
  file.directory:
    - force: True

/media/archlinux-2019.01.01-x86_64.iso:
  file.managed:
    - source: salt://{{ tpldir }}/vmIsos/archlinux-2019.01.01-x86_64.iso
    - mode:   644

mountArchIso:
  cmd.run:
    - name: mount -o loop,ro archlinux-2019.01.01-x86_64.iso /mnt/arch
    - cwd: /media
    - require:
      - /media/archlinux-2019.01.01-x86_64.iso
      - /mnt/arch

