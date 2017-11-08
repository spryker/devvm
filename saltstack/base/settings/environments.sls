#
# Parse per-environment settings
#
{% import_yaml 'settings/port_numbering.sls' as port %}

#
# Parse environments-specific settings
#
{%- set environments = pillar.environments %}
{%- for environment, environment_details in environments.items() %}

# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_static = salt['grains.get']('environments:' + environment + ':static:hostname', None) %}
{%- if grains_hostname_static != None %}
{%-   do environments[environment].static.update ({ 'hostname': grains_hostname_static}) %}
{%- endif %}

# Generate Jenkins ports
{%- do environments[environment].update ({ 'jenkins': { 'port': '1' + port['environment'][environment]['port'] + '00' + '7' }}) %}

# Generate http static assets ports
{%- do environments[environment].static.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '2' }) %}

# Generate Elasticsearch ports
{%- do environments[environment]['elasticsearch'].update ({
      'http_port': '1' + port['environment'][environment]['port'] + '00' + '5',
      'transport_port': '2' + port['environment'][environment]['port'] + '00' + '5',
}) %}

# Not using Redis-as-a-Service?
{%- if salt['pillar.get']('hosting:external_redis', '') == '' %}
# Generate Redis ports
{%- do environments[environment].redis.update ({
      'port': '1' + port['environment'][environment]['port'] + '00' + '9'
}) %}
{%- else %}
{%- do environments[environment].update ({
      'redis': { 'port': 6379 }
}) %}
{%- endif %}

#
# Parse store settings
#
{%- for store, store_details in environment_details.stores.items() %}

# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostnames_yves = salt['grains.get']('environments:' + environment + ':stores:' + store + ':yves:hostnames', None) %}
{%- if grains_hostnames_yves != None %}
{%-   do environments[environment]['stores'][store].yves.update ({ 'hostnames': grains_hostnames_yves}) %}
{%- endif %}
{%- set grains_hostname_zed   = salt['grains.get']('environments:' + environment + ':stores:' + store + ':zed:hostname', None) %}
{%- if grains_hostname_zed != None %}
{%-   do environments[environment]['stores'][store].zed.update ({ 'hostname': grains_hostname_zed}) %}
{%- endif %}


# Generate Yves/Zed ports
{%- do environments[environment]['stores'][store].yves.update ({ 'port': '1' + port['environment'][environment]['port'] + port['store'][store]['appdomain'] + '0' }) %}
{%- do environments[environment]['stores'][store].zed.update  ({ 'port': '1' + port['environment'][environment]['port'] + port['store'][store]['appdomain'] + '1' }) %}

# Generate store locale settings
{%- do environments[environment]['stores'][store].update ({ 'locale': port['store'][store]['locale'], 'appdomain': port['store'][store]['appdomain'] }) %}

# Generate RabbitMQ vhost names / credentials
{%- do environments[environment]['stores'][store].update({
  'rabbitmq': {
    'username': store + '_' + environment,
    'password': environment_details.rabbitmq.password,
    'vhost':    '/' + store + '_' + environment + '_zed'
  }
}) %}


# Not using MySQL-as-a-service?
{%- if salt['pillar.get']('hosting:external_mysql', '') == '' %}

# Generate SQL database names
{%- do environments[environment]['stores'][store].zed.update({
  'database': {
    'database': store + '_' + environment + '_zed',
    'hostname': environment_details.database.zed.hostname,
    'username': environment_details.database.zed.username,
    'password': environment_details.database.zed.password
  }
}) %}
{%- do environments[environment]['stores'][store].update({
  'dump': {
    'database': {
      'database': store + '_' + environment + '_dump',
      'hostname': environment_details.database.zed.hostname,
      'username': environment_details.database.zed.username,
      'password': environment_details.database.zed.password
    }
  }
}) %}

{%- else %}
# Using MySQL-as-a-service
{%- set mysql_hostname = salt['pillar.get']('hosting:external_mysql') %}

# Generate SQL database names
{%- do environments[environment]['stores'][store].zed.update({
  'database': {
    'database': store + '_' + environment + '_zed',
    'hostname': mysql_hostname,
    'username': environment_details.database.zed.username,
    'password': environment_details.database.zed.password
  }
}) %}
{%- do environments[environment]['stores'][store].update({
  'dump': {
    'database': {
      'database': store + '_' + environment + '_dump',
      'hostname': mysql_hostname,
      'username': environment_details.database.zed.username,
      'password': environment_details.database.zed.password
    }
  }
}) %}
{%- endif %}

{%- endfor %}
{%- endfor %}
