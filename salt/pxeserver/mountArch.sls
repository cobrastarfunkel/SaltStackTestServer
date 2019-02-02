

/mnt/arch:
  file.directory:
    - force: True

/media/archlinux-2019.01.01-x86_64.iso:
  file.managed:
    - source: salt://{{ tpldir }}/vmIsos/archlinux-2019.01.01-x86_64.iso
    - mode:   644

{% if not salt['file.directory_exists']('/mnt/arch/arch') %}
mountArchIso:
  cmd.run:
    - name: mount -o loop,ro archlinux-2019.01.01-x86_64.iso /mnt/arch
    - cwd: /media
    - require:
      - /media/archlinux-2019.01.01-x86_64.iso
      - /mnt/arch
{% endif %}

move_arch_boot_files:
  cmd.run:
    - name: cp -rp /mnt/arch/arch /var/lib/tftpboot/ 
    - require:
      - /media/archlinux-2019.01.01-x86_64.iso

default_menu:
  file.managed:
      - source: salt://{{ tpldir }}/files/default
      - name: /var/lib/tftpboot/pxelinux.cfg/default
      - mode: 644
