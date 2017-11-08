#
# Install RabbitMQ (message queue broker)
#

rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server

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
