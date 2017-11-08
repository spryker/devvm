#
# Manage RabbitMQ credentials
#

# Delete default guest user
rabbitmq_user_guest:
  rabbitmq_user.absent:
    - name: guest

# Create rabbitmq user and vhost for each environment/store
{%- from 'settings/init.sls' import settings with context %}
{%- for environment, environment_details in settings.environments.items() %}
{%- for store in pillar.stores %}

rabbitmq_vhost_{{ store }}_{{ environment }}_zed:
  rabbitmq_vhost.present:
    - name: {{ settings.environments[environment].stores[store].rabbitmq.vhost }}

rabbitmq_user_{{ store }}_{{ environment }}_zed:
  rabbitmq_user.present:
    - name: {{ settings.environments[environment].stores[store].rabbitmq.username }}
    - password: {{ settings.environments[environment].stores[store].rabbitmq.password }}
    - perms:
      - {{ settings.environments[environment].stores[store].rabbitmq.vhost }}:
        - '.*'
        - '.*'
        - '.*'
    - require:
      - rabbitmq_vhost: rabbitmq_vhost_{{ store }}_{{ environment }}_zed

{% endfor %}
{% endfor %}

# Create admin username for GUI
{%- set admin_user = salt['pillar.get']('rabbitmq:admin_user', False) %}
{%- if admin_user %}
rabbitmq_admin_user:
  rabbitmq_user.present:
    - name: {{ pillar.rabbitmq.admin_user.username }}
    - password: {{ pillar.rabbitmq.admin_user.password }}
    - tags:
      - administrator
{%- endif %}
