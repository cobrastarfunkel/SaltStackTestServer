systemctl enable firewalld && systemctl enable firewalld:
  cmd.run

# Create the saltstack firewall service
saltstack:
  firewalld.service:
    - name: saltstack
    - ports:
      - 4505/tcp
      - 4506/tcp

# Add standard rules to public
public:
  firewalld.present:
    - name: public
    - services:
      - saltstack
      - ssh
    - prune_services: False
