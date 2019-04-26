# If coming from git create a directory for your iso's in pxeserver named vmIsos
{# 
    TODO: Base these on the os pillar of the host that needs to be kicked maybe, maybe not.
    CentOS needs more than 1gb of ram for the pxeboot to succeed.
 #}
{% set archiso = 'archlinux-2019.01.01-x86_64.iso' %}
{% set centos_iso = 'CentOS-7-x86_64-Minimal-1810.iso' %}


/mnt/arch:
  file.directory:
    - force:      True

/var/www/arch:
  file.directory:
    - force: True
    - require:
      - sls: {{ tpldir }}.pxePacksPorts

/media/{{ archiso }}:
  file.managed:
    - source:     salt://{{ tpldir }}/vmIsos/{{ archiso }}
    - mode:       644

{% if not salt['file.directory_exists']('/mnt/arch/arch') %}
mountArchIso:
  cmd.run:
    - name:       mount -o loop,ro {{ archiso }} /mnt/arch
    - cwd:        /media
    - require:
      - /media/{{ archiso }}
      - /mnt/arch
{% endif %}

move_arch_boot_files:
  cmd.run:
    - name:       cp -rp /mnt/arch/arch /var/lib/tftpboot/ 
    - require:
      - /media/{{ archiso }}

move_arch_for_http:
  cmd.run:
    - name:       cp -rp /mnt/arch/arch /var/www/
    - require:
      - /var/www/arch

/centos:
  file.directory:
    - force:      True

/var/lib/tftpboot/centos:
  file.directory:
    - force: True

/media/{{ centos_iso }}:
  file.managed:
    - source:     salt://{{ tpldir }}/vmIsos/{{ centos_iso }}
    - mode:       644

{% if not salt['file.directory_exists']('/centos/images') %}#}
mountCentIso:
  cmd.run:
    - name:       mount -o loop,ro {{ centos_iso }} /centos
    - cwd:        /media
    - require:
      - /media/{{ centos_iso }}
      - /centos
{% endif %}

move_cent_boot_files:
  cmd.run:
    - name:       cp -rp /centos/* /var/ftp/pub/ && cp -p /centos/images/pxeboot/* /var/lib/tftpboot/centos
    - require:
      - /media/{{ centos_iso }}
      - /var/lib/tftpboot/centos

    {#
default_menu:
  file.managed:
      - source:   salt://{{ tpldir }}/files/pxe_menu/default
      - name:     /var/lib/tftpboot/pxelinux.cfg/default
      - mode:     644
      - template: jinja
      #}
