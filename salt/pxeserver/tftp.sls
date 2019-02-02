
vsftpd_conf:
  file.managed:
    - source:    salt://{{ tpldir }}/files/tftp
    - name:      /etc/xinetd.d/tftp
    - mode:      644
    - require: 
      - sls: {{ tpldir }}.pxePacksPorts

vsftpd:
  service.running:
    - enable:    False
    - reload:    True
    - watch:
      - vsftpd_conf

bios_tftp_dirs:
  file.directory:
    - name:      /var/lib/tftpboot/pxelinux/pxelinux.cfg
    - user:      root
    - group:     root
    - dir_mode:  755
    - file_mode: 644
    - makedirs:  True

move_boot_loaders:
  cmd.run:
    - name:      cp -rp /usr/share/syslinux/* /var/lib/tftpboot
    - require:   
      - sls: {{ tpldir }}.pxePacksPorts

