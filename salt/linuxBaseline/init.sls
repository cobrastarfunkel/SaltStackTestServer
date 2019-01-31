include:
  - {{ tpldir }}.firewall
{% if grains['os_family'] == 'RedHat' %}
  - {{ tpldir }}.rhel_based
{% else %}
# TODO:  Add Debian confs
{% endif %}

# Probably will say vim and git fail when they don't.  Not sure why at the moment.
# This makes it so we can't make the script below require these packages to be
# installed before it runs, but the script is dependent on git.  Salt usually
# does things in sequence but having a require statement would be better.
standardPackages:
  pkg.installed:
    - pkgs:
      - vim
      - git
      - screen

# screen config
/etc/screenrc:
  file.managed:
    - source:     salt://{{ tpldir }}/files/screenrc
    - mode:       644

# Adds Vundle to Home dir for users
salt://{{ tpldir }}/files/userId.sh:
  cmd.script:
    - cwd: /run
