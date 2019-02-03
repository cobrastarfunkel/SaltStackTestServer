{% for network, data in pillar.get('networks', {}).items() %}

  {% for host, host_data in data.get('hosts', {}).items() %}

pxe_{{ host }}_menu:
  file.managed:
    - source:   salt://{{ tpldir }}/files/pxe_menu/{{ host_data.os|lower }}
    - name:     /var/lib/tftpboot/pxelinux.cfg/{{ host_data.mac|lower|replace(":", "-") }}
    - mode:     644
    - template: jinja
    - defaults:
        server: {{ data.next_server }}

  {% endfor %}

{% endfor %}

dhcp_conf:
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
