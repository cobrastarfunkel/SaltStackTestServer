
tftp_conf:
  file.managed:
    - source:    salt://{{ tpldir }}/files/tftp
    - name:      /etc/xinetd.d/tftp
    - mode:      644
    - require: 
      - sls: {{ tpldir }}.pxePacksPorts

xinetd:
  service.running:
    - enable:    False
    - reload:    True
    - watch:
      - tftp_conf

vsftpd:
  service.running:
    require:
      - xinetd

bios_tftp_dirs:
  file.directory:
    - name:      /var/lib/tftpboot/pxelinux.cfg
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

