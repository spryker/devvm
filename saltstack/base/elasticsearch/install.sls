#
# Install Elasticsearch and plugins configured in pillar
#

elasticsearch-requirements:
  pkg.installed:
    - pkgs:
      - openjdk-8-jre-headless

elasticsearch:
  pkg.installed:
    - version: {{ pillar.elasticsearch.version }}
    - require:
      - pkg: elasticsearch-requirements

# For each plugin - we need to restart Elasticsearch service on each environment
{%- for shortname, plugin in pillar.elasticsearch.plugins.items() %}
/usr/share/elasticsearch/bin/plugin install {% if plugin.url is defined %}{{ plugin.url }}{% else %}{{ plugin.name }}{% endif %}:
  cmd.run:
    - unless: test -d /usr/share/elasticsearch/plugins/{{ shortname }}
    - require:
      - pkg: elasticsearch
    - watch_in:
{%- for environment, environment_details in pillar.environments.items() %}
{%- if 'skip_instance_setup' not in environment_details.elasticsearch %}
      - service: elasticsearch-{{ environment }}
{%- endif %}
{%- endfor %}
{%- endfor %}
