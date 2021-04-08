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

# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_configurator = salt['grains.get']('environments:' + environment + ':configurator:hostname', None) %}
{%- if grains_hostname_configurator != None %}
{%-   do environments[environment].configurator.update ({ 'hostname': grains_hostname_configurator}) %}
{%- endif %}
# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_backofficede = salt['grains.get']('environments:' + environment + ':backofficede:hostname', None) %}
{%- if grains_hostname_backofficede != None %}
{%-   do environments[environment].backofficede.update ({ 'hostname': grains_hostname_backofficede}) %}
{%- endif %}
# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_backofficeat = salt['grains.get']('environments:' + environment + ':backofficeat:hostname', None) %}
{%- if grains_hostname_backofficeat != None %}
{%-   do environments[environment].backofficeat.update ({ 'hostname': grains_hostname_backofficeat}) %}
{%- endif %}
# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_backofficeus = salt['grains.get']('environments:' + environment + ':backofficeus:hostname', None) %}
{%- if grains_hostname_backofficeus != None %}
{%-   do environments[environment].backofficeus.update ({ 'hostname': grains_hostname_backofficeus}) %}
{%- endif %}
# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_backendapide = salt['grains.get']('environments:' + environment + ':backendapide:hostname', None) %}
{%- if grains_hostname_backendapide != None %}
{%-   do environments[environment].backendapide.update ({ 'hostname': grains_hostname_backendapide}) %}
{%- endif %}
# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_backendapiat = salt['grains.get']('environments:' + environment + ':backendapiat:hostname', None) %}
{%- if grains_hostname_backendapiat != None %}
{%-   do environments[environment].backendapiat.update ({ 'hostname': grains_hostname_backendapiat}) %}
{%- endif %}
# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_backendapius = salt['grains.get']('environments:' + environment + ':backendapius:hostname', None) %}
{%- if grains_hostname_backendapius != None %}
{%-   do environments[environment].backendapius.update ({ 'hostname': grains_hostname_backendapius}) %}
{%- endif %}
# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_backendgatewayde = salt['grains.get']('environments:' + environment + ':backendgatewayde:hostname', None) %}
{%- if grains_hostname_backendgatewayde != None %}
{%-   do environments[environment].backendgatewayde.update ({ 'hostname': grains_hostname_backendgatewayde}) %}
{%- endif %}
# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_backendgatewayat = salt['grains.get']('environments:' + environment + ':backendgatewayat:hostname', None) %}
{%- if grains_hostname_backendgatewayde != None %}
{%-   do environments[environment].backendgatewayat.update ({ 'hostname': grains_hostname_backendgatewayat}) %}
{%- endif %}
# If hostnames are defined in grains - overwrite setings from pillar
{%- set grains_hostname_backendgatewayus = salt['grains.get']('environments:' + environment + ':backendgatewayus:hostname', None) %}
{%- if grains_hostname_backendgatewayus != None %}
{%-   do environments[environment].backendgatewayus.update ({ 'hostname': grains_hostname_backendgatewayus}) %}
{%- endif %}

# Generate Jenkins ports
{%- do environments[environment].update ({ 'jenkins': { 'port': '1' + port['environment'][environment]['port'] + '00' + '7' }}) %}

# Generate http static assets ports
{%- do environments[environment].static.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '2' }) %}

# Generate http Configurator assets ports
{%- do environments[environment].configurator.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '3' }) %}
# Generate http Backoffice assets ports
{%- do environments[environment].backofficede.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '3' }) %}
{%- do environments[environment].backofficeat.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '3' }) %}
{%- do environments[environment].backofficeus.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '3' }) %}
# Generate http Backendapi assets ports
{%- do environments[environment].backendapide.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '3' }) %}
{%- do environments[environment].backendapiat.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '3' }) %}
{%- do environments[environment].backendapius.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '3' }) %}
# Generate http Backendgateway assets ports
{%- do environments[environment].backendgatewayde.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '3' }) %}
{%- do environments[environment].backendgatewayat.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '3' }) %}
{%- do environments[environment].backendgatewayus.update ({ 'port': '1' + port['environment'][environment]['port'] + '00' + '3' }) %}

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
{%- set grains_hostname_glue  = salt['grains.get']('environments:' + environment + ':stores:' + store + ':glue:hostname', None) %}
{%- if grains_hostname_glue != None %}
{%-   do environments[environment]['stores'][store].glue.update ({ 'hostname': grains_hostname_glue}) %}
{%- endif %}


# Generate Yves/Zed ports
{%- do environments[environment]['stores'][store].yves.update ({ 'port': '1' + port['environment'][environment]['port'] + port['store'][store]['appdomain'] + '0' }) %}
{%- do environments[environment]['stores'][store].zed.update  ({ 'port': '1' + port['environment'][environment]['port'] + port['store'][store]['appdomain'] + '1' }) %}
{%- do environments[environment]['stores'][store].glue.update ({ 'port': '1' + port['environment'][environment]['port'] + port['store'][store]['appdomain'] + '2' }) %}

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
