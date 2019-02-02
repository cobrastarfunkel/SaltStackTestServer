vBoxOne:
  subnet:             10.0.0.0
  gateway:            10.0.2.2
  netmask:            255.0.0.0
  domain_name:       'test.com'
  domain_server:      10.0.2.2
  next_server:        10.0.2.15
  range:              10.0.2.10 10.0.2.20

  hosts:
    archTest:
      name:           'archLinux'
      mac:            08:00:27:BC:58:C5
      ip_addr:        10.0.2.14
      os:             'arch'
