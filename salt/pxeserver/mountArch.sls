

/mnt/arch:
  file.directory:
    - force: True

/dev/shm/archlinux-2019.01.01-x86_64.iso:
  file.managed:
    - source: salt://{{ tpldir }}/vmIsos/archlinux-2019.01.01-x86_64.iso
    - mode:   644

mountArchIso:
  cmd.run:
    - name: mount -o loop,ro archlinux-2019.01.01-x86_64.iso /mnt/arch
    - cwd: /dev/shm
    - require:
      - /dev/shm/archlinux-2019.01.01-x86_64.iso
      - /mnt/arch

