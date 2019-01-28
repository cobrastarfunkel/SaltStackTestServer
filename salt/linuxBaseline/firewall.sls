

saltstack:
  firewalld.service:
    - name: saltstack
    - ports:
      - 4505/tcp
      - 4506/tcp


public:
  firewalld.present:
    - name: public
    - services:
      - saltstack
      - ssh
    - prune_services: False
