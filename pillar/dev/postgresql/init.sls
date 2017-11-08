# Configuration of PostgreSQL database server.
#
# Parameters and values from this file are placed in postgresql.conf file
# For the documentation of the parameters, please check PostgreSQL documentation

postgresql:
  # Optional, default: 64MB
  shared_buffers: 64MB

  # Optional, default: 8MB
  temp_buffers: 8MB

  # Optional, default: 8MB
  work_mem: 8MB

  # Optional, default: 128MB
  maintenance_work_mem: 128MB

  # Optional, default: 64MB
  effective_cache_size: 64MB

  # Optional, default: 1024
  max_connections: 32

  # Optional, if not present - additional admin account will not be created
  superuser:
    username: admin
    password: mate20mg
