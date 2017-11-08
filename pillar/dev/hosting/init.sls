# Values for hosting scenarios


hosting:

  # Name of the sls file in hosting state (the hosting state must have
  # the substate with the same name, as specified here).
  # Mandatory, no default value
  provider: vagrant

  # Country of debian mirror to use for installing packages
  # Optional, default: cloudfront.debian.net
  debian_mirror: ftp.de.debian.org

  # Network part of created MySQL users
  # Optional, default: %
  mysql_network: "%"

  # Network allowed for PostgreSQL access (in pg_hba.conf)
  # Optional, default: none
  postgresql_network: 10.0.0.0/8

  # Network interface used for communication between spryker components
  # Mandatory, default: lo (works on localhost only)
  #project_network_interface: eth0

  # List of whitelisted IP's for HTTP authorization
  # It should include local IP addresses or networks of Yves/Zed servers
  # HTTP API requests between Yves and Zed must be whitelisted!
  # Optional, default: - 127.0.0.1
  http_auth_whitelist:
    - 127.0.0.1/32
    - 10.10.0.0/24

  # Support for managed services:
  # If the values for external_* keys are non-empty, then the setup of service
  # will be omitted and endpoints specified below will be used. It can be used
  # if the service is provided by datacenter as-a-service.
  #
  # Those settings do not have effect on dev environment!
  # Optional, default: no value

  #external_mysql: 127.0.0.1
  #external_elasticsearch:
  #  - 127.0.0.1
  #  - 127.0.0.2
  #external_redis: 127.0.0.4
