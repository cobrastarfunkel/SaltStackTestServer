vBoxOne:
  subnet:             192.168.56.0
  gateway:            192.168.56.1
  netmask:            255.255.255.0
  domain_name:       'test.com'
  domain_server:      192.168.56.1
  next_server:        192.168.56.2
  range:              192.168.56.50 192.168.56.60

  hosts:
    archTest:
      name:           'archLinux'
      mac:            08:00:27:BC:58:C5
      ip_addr:        192.168.56.5
      os:             'arch'
