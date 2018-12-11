#
# Install RabbitMQ (message queue broker)
#

rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server

{% if salt['pillar.get']('rabbitmq:node_name', False) %}
/etc/rabbitmq/rabbitmq-env.conf:
  file.managed:
    - contents:
      - NODENAME={{ salt['pillar.get']('rabbitmq:node_name') }}
    - require:
      - pkg: rabbitmq-server
    - require_in:
      - service: rabbitmq-service
    - watch_in:
      - service: rabbitmq-service
{% endif %}


rabbitmq-service:
  service.running:
    - name: rabbitmq-server
    - enable: {{ salt['pillar.get']('rabbitmq:enabled', True) }}
    - require:
      - pkg: rabbitmq-server

enable-rabbitmq-management:
  cmd.run:
    - name: rabbitmq-plugins enable rabbitmq_management
    - unless: rabbitmq-plugins list | grep '\[[eE]\*\] rabbitmq_management '
    - require:
      - service: rabbitmq-server
