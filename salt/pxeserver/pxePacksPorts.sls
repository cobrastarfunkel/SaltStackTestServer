
pxe_ports:
  firewalld.present:
    - name: public
    - services:
      - tftp
      - dhcp
    - prune_services: False

pxeserver-pkgs:
  pkg.installed:
    - pkgs:
      - tftp-server
      - dhcp

xinetd:
  service.running:
    - enable: True
    - require: 
      - pxeserver-pkgs

dhcpd:
  service.running:
    - enable: True
    - require: 
      - pxeserver-pkgs


