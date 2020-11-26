#
# Install Elasticsearch and plugins configured in pillar
#

elasticsearch-requirements:
  pkg.installed:
    - pkgs:
      - adoptopenjdk-8-hotspot
      - policykit-1

elasticsearch:
  pkg.installed:
    - version: {{ pillar.elasticsearch.version }}
    - require:
      - pkg: elasticsearch-requirements

# Disable default elasticsearch service
# Each environment will get its own ES instance running.
disable-elasticsearch-service:
  service.dead:
    - name: elasticsearch
    - enable: False

# For each plugin - we need to restart Elasticsearch service on each environment
# This is not maintained anymore since elasticsearch 5.x
#
# {%- for shortname, plugin in salt['pillar.get']('elasticsearch:plugins', {}).items() %}
# /usr/share/elasticsearch/bin/plugin install {% if plugin.url is defined %}{{ plugin.url }}{% else %}{{ plugin.name }}{% endif %}:
#   cmd.run:
#     - unless: test -d /usr/share/elasticsearch/plugins/{{ shortname }}
#     - require:
#       - pkg: elasticsearch
#     - watch_in:
{%- for environment, environment_details in pillar.environments.items() %}
{%- if 'skip_instance_setup' not in environment_details.elasticsearch %}
      - service: elasticsearch-{{ environment }}
{%- endif %}
{%- endfor %}
# {%- endfor %}
