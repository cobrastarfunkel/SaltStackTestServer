include:
  - {{ tpldir }}.firewall
{% if grains['os_family'] == 'RedHat' %}
  - {{ tpldir }}.rhel_based
{% else %}
# TODO:  Add Debian confs
{% endif %}

/etc/screenrc:
  file.managed:
    - source:     salt://{{ tpldir }}/files/screenrc
    - mode:       644
