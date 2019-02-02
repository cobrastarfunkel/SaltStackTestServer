
pxe_ports:
  firewalld.present:
    - name: public
    - interfaces:
    {% for interface in salt['grains.get']('ip_interfaces') %}
      {% if interface != 'lo' %}
      - {{ interface }}
      {% endif %}
    {% endfor %}
    - services:
      - tftp
      - dhcp
    - ports:
      - 67/udp
      - 68/udp
      - 69/udp
      - 21/tcp
      - 20/tcp
    - prune_services: False

pxeserver-pkgs:
  pkg.installed:
    - pkgs:
      - xinetd
      - tftp
      - dhcp
      - syslinux



