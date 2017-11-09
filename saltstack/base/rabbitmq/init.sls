#
# Install RabbitMQ (Message Queue)
#

include:
  - .setup

# Create users only if service is enabled
{% if salt['pillar.get']('rabbitmq:enabled', False) %}
  - .credentials
{% endif %}

# Include autoupdate if configured to do so
{% if salt['pillar.get']('autoupdate:rabbitmq', False) %}
  - .update
{% endif %}
