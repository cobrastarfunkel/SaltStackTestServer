
# TODO: Create pillar that defines the os that will be used to kick a server
# so different iso's can be mounted depending on what is going to be pxe booted

include:
  - {{ tpldir }}.pxePacksPorts
  - {{ tpldir }}.mountArch
  - {{ tpldir }}.dhcp
  - {{ tpldir }}.tftp


