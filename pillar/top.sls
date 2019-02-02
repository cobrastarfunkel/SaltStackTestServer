base:
  "*":
    - test
    - jinjaTestDir

  provisioning:
    - match: nodegroup
    - pxeserver
