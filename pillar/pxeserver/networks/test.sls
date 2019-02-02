vBoxTwo:
  subnet:             192.168.3.0
  gateway:            192.168.3.2
  netmask:            255.255.255.0
  domain_name:       'test2.com'
  domain_server:      192.168.3.2
  next_server:        192.168.3.4
  range:              192.168.3.10 192.168.3.20

  hosts:
    cenTest:
      name:           'centest'
      mac:            08:00:26:BC:58:C5
      ip_addr:        192.168.3.13
      os:             'centos'
