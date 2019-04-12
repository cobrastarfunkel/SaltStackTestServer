
{% import_yaml '/srv/salt/groupsTest.yaml' as groups %}

{% if grains['id'] in groups.one %}
account:
  - Test

{% endif %}

salt_master:   salt-master
