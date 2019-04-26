{#
   Main Key value for the Networks that will be kicked. 
   Create a file in the networks directory for each network
   that you want to pxeboot from.
 #}

include:
  - {{ tpldir }}.networks.virtualBoxTest:
      key: networks
