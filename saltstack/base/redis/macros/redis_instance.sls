#
# Macro: Setup one Elasticsearch instance
#

{% macro redis_instance(environment, environment_details, settings) -%}

{% if 'skip_instance_setup' not in environment_details.redis %}
/tmp/b-{{ environment }}:
  file.managed:
    - contents: {{ environment_details }}

/data/shop/{{ environment }}/shared/redis:
  file.directory:
    - user: redis
    - group: redis
    - mode: 700
    - require:
      - file: /data/shop/{{ environment }}/shared

/data/logs/{{ environment }}/redis:
  file.directory:
    - user: redis
    - group: redis
    - mode: 755
    - require:
      - file: /data/logs/{{ environment }}

{%- if 'systemd' in grains %}
{%- set service_name = 'redis-server-' + environment %}
/etc/systemd/system/redis-server-{{ environment }}.service:
  file.managed:
    - template: jinja
    - source: salt://redis/files/etc/systemd/system/redis-server.service
    - context:
      environment: {{ environment }}

redis-server-{{ environment }}:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/redis-server-{{ environment }}.service

{%- else %}
{%- set service_name = 'redis-services' %}
{%- endif %}

/etc/redis/redis_{{ environment }}.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://redis/files/redis_instance/etc/redis/redis.conf
    - context:
      environment: {{ environment }}
      environment_details: {{ environment_details }}
      settings: {{ settings }}
    - require:
      - file: /data/shop/{{ environment }}/shared/redis
      - file: /data/logs/{{ environment }}/redis
    - watch_in:
      - service: {{ service_name }}

{%- endif %}
{%- endmacro %}
