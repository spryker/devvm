#
# Setup for multiple environments of Spryker
#
# This implementation is Spryker-specific and it takes data from Spryker pillars
# Instances created here are used by Spryker and are required for production use.
# Each environment works on seperate elasticsearch instance.
#
{% from 'settings/init.sls' import settings with context %}
{% from 'elasticsearch/macros/elasticsearch_instance.sls' import elasticsearch_instance with context %}

/etc/logrotate.d/elasticsearch-instances:
  file.managed:
    - source: salt://elasticsearch/files/etc/logrotate.d/elasticsearch-instances

# Update the default elasticsearch configuration file
/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://elasticsearch/files/elasticsearch_instance/etc/elasticsearch/elasticsearch.yml

{%- for environment, environment_details in pillar.environments.items() %}
{{ elasticsearch_instance(environment, environment_details, settings) }}
{%- endfor %}
