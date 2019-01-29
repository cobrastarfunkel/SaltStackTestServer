base:
  linux-minions:
    - match: nodegroup
    - linuxBaseline
  
  provisioning:
    - match: nodegroup
    - pxeserver
