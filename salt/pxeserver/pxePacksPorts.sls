
pxe_ports:
  firewalld.present:
    - name: public
    - services:
      - tftp
      - dhcp
    - ports:
      - 67/udp
      - 68/udp
    - prune_services: False

pxeserver-pkgs:
  pkg.installed:
    - pkgs:
      - vsftpd
      - dhcp
      - syslinux



