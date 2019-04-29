{% for network, data in pillar.get('networks', {}).items() %}

  {% for host, host_data in data.get('hosts', {}).items() %}

pxe_{{ host }}_menu:
  file.managed:
    - source:   salt://{{ tpldir }}/files/pxe_menu/{{ host_data.os|lower }}
    {% if host_data.boot == 'bios' %}
    - name:     /var/lib/tftpboot/pxelinux.cfg/01-{{ host_data.mac|lower|replace(":", "-") }}
    {% else %}
    - name:     /var/lib/tftpboot/grub.cfg-01-{{ host_data.mac|lower|replace(":", "-") }}
    {% endif %}
    - mode:     644
    - template: jinja
    - defaults:
        server: {{ data.next_server }}
        host:   {{ host }}
        boot:   {{ host_data.boot }}

centos7_{{ host }}_ks:
  file.managed:
    - source:   salt://{{ tpldir }}/files/kickstart/centos7.ks
    - name:     /var/ftp/pub/centos7{{ host }}.ks
    - mode:     644
    - template: jinja
    - defaults:
         ipaddr:      {{ host_data.ip_addr }}
         gateway:     {{ data.gateway }}
         macaddr:     {{ host_data.mac|lower }}
         netmask:     {{ data.netmask }}
         host:        {{ host }}
         next_server: {{ data.next_server }}
         boot:   {{ host_data.boot }}

  {% endfor %}

{% endfor %}

dhcp_conf:
  file.managed:
    - source: salt://{{ tpldir }}/files/dhcpd.conf
    - name:   /etc/dhcp/dhcpd.conf
    - mode:   644
    - require:
      - sls:    {{ tpldir }}.pxePacksPorts
    - template: jinja

dhcpd:
  service.running:
    - enable: True

httpd_conf:
  file.managed:
    - source:  salt://{{ tpldir }}/files/pxe.conf
    - name:    /etc/httpd/conf.d/pxe.conf
    - mode:    644
    - require:
        - sls: {{ tpldir }}.pxePacksPorts

httpd:
  service.running:
    - require:
      - httpd_conf
