
dhcpd_confs:
  file.managed:
    - source: salt://{{ tpldir }}/files/dhcpd.conf
    - name:   /etc/dhcp/dhcpd.conf
    - mode:   644
    - require:
      - sls: {{ tpldir }}.pxePacksPorts
    - template: jinja

dhcpd:
  service.running:
    - enable: True
    - reload: True
    - watch: 
      - dhcpd_confs
