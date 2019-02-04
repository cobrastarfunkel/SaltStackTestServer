{#
    Network config for pxebooting
 #}

vBoxOne:   # Network name
  subnet:             192.168.0.0                 # Subnet
  gateway:            192.168.0.1                 # Network Default gateway
  netmask:            255.255.255.0                # Subnet Mask
  domain_name:       'test.com'                    # domain name
  domain_server:      192.168.0.1                 # dns server
  next_server:        192.168.0.15                 # tftp Server
  range:              192.168.0.50 192.168.0.60  # Ranges for dhcp

  hosts:                                 # Dictionary of hosts for this network
    archTest:                            # hostname
      mac:            08:00:27:BC:58:C5  # Mac address of nic on network that pxeserver interface is on
      ip_addr:        192.168.0.17       # Ip addr of host
      os:             'arch'             # os to be installed
{#
    TODO: Use os value to determine the pxemenu that is used on the pxeserver
 #}
