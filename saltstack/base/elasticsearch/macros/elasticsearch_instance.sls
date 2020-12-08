#
# Macro: Setup one Elasticsearch instance
#

{% macro elasticsearch_instance(environment, environment_details, settings) -%}

{% if 'skip_instance_setup' not in environment_details.elasticsearch %}

# Data directory
/data/shop/{{ environment }}/shared/elasticsearch:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - mode: 700
    - makedirs: True

# Log directory
/data/logs/{{ environment }}/elasticsearch:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - mode: 755
    - makedirs: True

# Symlink for original log location, for gc.log
/var/log/elasticsearch-{{ environment }}:
  file.symlink:
    - target: /data/logs/{{ environment }}/elasticsearch
    - require:
      - file: /data/logs/{{ environment }}/elasticsearch

# Service configuration
/etc/default/elasticsearch-{{ environment }}:
  file.managed:
    - source: salt://elasticsearch/files/elasticsearch_instance/etc/default/elasticsearch
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - context:
      environment: {{ environment }}
      settings: {{ settings|tojson }}
    - watch_in:
      - service: elasticsearch-{{ environment }}

# Symlink for Elasticsearch default configuration
/etc/default/elasticsearch:
  file.symlink:
    - target: /etc/default/elasticsearch-{{ environment }}
    - force: True
    - require:
      - file: /etc/default/elasticsearch-{{ environment }}

# Service init script
/etc/systemd/system/elasticsearch-{{ environment }}.service:
  file.managed:
    - source: salt://elasticsearch/files/elasticsearch_instance/etc/systemd/system/elasticsearch.service
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - context:
      environment: {{ environment }}

# Reload systemd on service creation
elasticsearch-{{ environment }}-systemctl-reload:
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
      - file: /etc/systemd/system/elasticsearch-{{ environment }}.service

# Configuration directory
/etc/elasticsearch-{{ environment }}:
  file.directory:
    - user: elasticsearch
    - group: root
    - mode: 755

# Configuration - main yaml file
/etc/elasticsearch-{{ environment }}/elasticsearch.yml:
  file.managed:
    - source: salt://elasticsearch/files/elasticsearch_instance/etc/elasticsearch/elasticsearch.yml
    - mode: 644
    - user: elasticsearch
    - group: root
    - template: jinja
    - context:
      environment: {{ environment }}
      environment_details: {{ environment_details|tojson }}
      settings: {{ settings|tojson }}
    - require:
      - file: /etc/elasticsearch-{{ environment }}
    - watch_in:
      - service: elasticsearch-{{ environment }}


# Configuration - jvm options
# this will work only with one env per server, as es startup script
# uses hardcoded locations: "$ES_HOME"/config/jvm.options, /etc/elasticsearch/jvm.options
/etc/elasticsearch-{{ environment }}/jvm.options:
  file.managed:
    - name: /etc/elasticsearch-{{ environment }}/jvm.options
    - source: salt://elasticsearch/files/elasticsearch_instance/etc/elasticsearch/jvm.options
    - mode: 644
    - user: elasticsearch
    - group: root
    - template: jinja
    - context:
      environment: {{ environment }}
      settings: {{ settings|tojson }}
    - require:
      - file: /etc/elasticsearch-{{ environment }}
    - watch_in:
      - service: elasticsearch-{{ environment }}

/etc/elasticsearch-{{ environment }}/log4j2.properties:
  file.managed:
    - source: salt://elasticsearch/files/elasticsearch_instance/etc/elasticsearch/log4j2.properties
    - mode: 644
    - user: elasticsearch
    - group: root
    - template: jinja
    - require:
      - file: /etc/elasticsearch-{{ environment }}
    - watch_in:
      - service: elasticsearch-{{ environment }}

# Configuration - (empty) scripts directory
/etc/elasticsearch-{{ environment }}/scripts:
  file.directory:
    - require:
      - file: /etc/elasticsearch-{{ environment }}

# Directory for elasticsearch pid
/var/run/elasticsearch:
  file.directory:
    - mode: 755
    - user: elasticsearch
    - group: elasticsearch

# Symlink for easier location of ES configs
/etc/elasticsearch/{{ environment }}:
  file.symlink:
    - target: /etc/elasticsearch-{{ environment }}
    - require:
      - file: /etc/elasticsearch-{{ environment }}

# Service
elasticsearch-{{ environment }}:
  service:
    - running
    - enable: True
    - require:
      - pkg: elasticsearch
      - file: /etc/systemd/system/elasticsearch-{{ environment }}.service
      - file: /data/shop/{{ environment }}/shared/elasticsearch
      - file: /data/logs/{{ environment }}/elasticsearch
      - file: /etc/default/elasticsearch-{{ environment }}
      - file: /etc/elasticsearch/{{ environment }}
      - file: /etc/elasticsearch-{{ environment }}/elasticsearch.yml
      - file: /etc/elasticsearch-{{ environment }}/log4j2.properties
      - file: /etc/elasticsearch-{{ environment }}/jvm.options
      - file: /etc/elasticsearch-{{ environment }}/scripts
      - cmd: elasticsearch-{{ environment }}-systemctl-reload

{%- endif %}
{%- endmacro %}
