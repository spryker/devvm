# RabbitMQ queue configuration

rabbitmq:
  # Enable RabbitMQ service?
  # Optional, default: True
  enabled: True

  # Parameters for administrator user for rabbitmq web GUI
  # If the section below is not specified, admin user for web interface will not be created
  # Optional, default: no value
  admin_user:
    username: admin
    password: mate20mg
