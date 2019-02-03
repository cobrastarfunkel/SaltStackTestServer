
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
      - ftp
      - http
    - prune_services: False

pxeserver-pkgs:
  pkg.installed:
    - pkgs:
      - xinetd
      - tftp
      - dhcp
      - httpd
      - syslinux

