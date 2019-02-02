
vsftpd_conf:
  file.managed:
    - source: salt://{{ tpldir }}/files/tftp
    - name:   /etc/xinetd.d/tftp
    - mode:   644
    - require: 
      - sls: {{ tpldir }}.pxePacksPorts

vsftpd:
  service.running:
    - enable: False
    - reload: True
    - watch:
      - vsftpd_conf
