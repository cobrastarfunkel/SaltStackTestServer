include:
  - {{ tpldir }}.firewall
{% if grains['os_family'] == 'RedHat' %}
  - {{ tpldir }}.rhel_based
{% else %}
# TODO:  Add Debian confs
{% endif %}

# screen config
/etc/screenrc:
  file.managed:
    - source:     salt://{{ tpldir }}/files/screenrc
    - mode:       644

# Adds Vundle to Home dir for users
salt://{{ tpldir }}/files/userId.sh:
  cmd.script

