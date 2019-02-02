base:
  "*":
    - test


# PxeServer Pillars
  provisioning:
    - match: nodegroup
    - pxeserver
