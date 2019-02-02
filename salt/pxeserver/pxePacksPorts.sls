
pxe_ports:
  firewalld.present:
    - name: public
    - services:
      - tftp
      - dhcp
    - ports:
      - 67/udp
      - 68/udp
      - 69/udp
    - prune_services: False

pxeserver-pkgs:
  pkg.installed:
    - pkgs:
      - xinetd
      - dhcp
      - syslinux



