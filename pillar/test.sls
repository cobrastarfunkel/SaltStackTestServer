
{% import_yaml 'groupsTest.yaml' as groups %}
{% import '/srv/salt/jinjaTest.jinja' as jinTest %}

{% if grains['id'] in groups.one %}
account:
  - Test

{% endif %}

{% if grains['id'] in jinTest.jinjaNodes.second %}
jinjaTest:
  - AnotherTest
{% endif %}

salt_master:   salt-master

{% if 'master' in grains['id'] %}
string_match:
  - Matched

{% endif %}
