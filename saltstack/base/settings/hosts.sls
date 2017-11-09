# Check if we run development VM? If so, no salt master is present, so mine mechanism is not available
# We assume that all services run on localhost
{%- if 'dev' in grains.roles %}
{%-   set app_hosts = ['localhost'] %}
{%-   set web_hosts = ['localhost'] %}
{%-   set job_hosts = ['localhost'] %}
{%-   set es_data_hosts = ['localhost'] %}
{%-   set es_log_hosts = ['localhost'] %}
{%-   set cron_master_host = 'localhost' %}
{%-   set queue_host = 'localhost' %}
{%-   set redis_host = 'localhost' %}
{%-   set publish_ip = 'localhost' %}

{%- else %}
# Use mine to fetch IP adresses from minions. Get the IP address of project_interface.
{%-   set netif = salt['pillar.get']('hosting:project_network_interface', 'lo') %}

# Limit mine search: only same host (qa), only same environment (non-qa)
{%-   if grains.environment == 'qa' %}
{%-     set envmatch = ' and G@id:' + grains.id %}
{%-   else %}
{%-     set envmatch = ' and G@environment:' + grains.environment %}
{%-   endif %}


# Get IP's of specific roles from mine.get of running instances
{%-   set app_hosts = [] %}
{%-   for hostname, network_settings in salt['mine.get']('G@roles:app' + envmatch, 'network.interfaces', expr_form = 'compound').items() %}
{%-     do app_hosts.append(network_settings[netif]['inet'][0]['address']) %}
{%-   endfor %}

{%-   set web_hosts = [] %}
{%-   for hostname, network_settings in salt['mine.get']('G@roles:web' + envmatch, 'network.interfaces', expr_form = 'compound').items() %}
{%-     do web_hosts.append(network_settings[netif]['inet'][0]['address']) %}
{%-   endfor %}

{%-   set job_hosts = [] %}
{%-   for hostname, network_settings in salt['mine.get']('G@roles:cronjobs' + envmatch, 'network.interfaces', expr_form = 'compound').items() %}
{%-     do job_hosts.append(network_settings[netif]['inet'][0]['address']) %}
{%-   endfor %}


{%-   if salt['pillar.get']('hosting:external_elasticsearch', '') == '' %}
{%-     set es_data_hosts = [] %}
{%-     for hostname, network_settings in salt['mine.get']('G@roles:elasticsearch' + envmatch, 'network.interfaces', expr_form = 'compound').items() %}
{%-       do es_data_hosts.append(network_settings[netif]['inet'][0]['address']) %}
{%-     endfor %}
{%-   else %}
{%-     set es_data_hosts = salt['pillar.get']('hosting:external_elasticsearch') %}
{%-   endif %}

{%-   if salt['pillar.get']('hosting:external_rabbitmq', '') == '' %}
{%-     set queue_host = salt['mine.get']('G@roles:queue' + envmatch, 'network.interfaces', expr_form = 'compound').items()[0][1][netif]['inet'][0].address %}
{%-   else %}
{%-     set queue_host = salt['pillar.get']('hosting:external_rabbitmq') %}
{%-   endif %}


{%-   set es_log_hosts = [] %}
{%-   for hostname, network_settings in salt['mine.get']('G@roles:elk_elasticsearch' + envmatch, 'network.interfaces', expr_form = 'compound').items() %}
{%-     do es_log_hosts.append(network_settings[netif]['inet'][0]['address']) %}
{%-   endfor %}

{%-   set cron_master_host = salt['mine.get']('G@roles:cronjobs' + envmatch, 'network.interfaces', expr_form = 'compound').items()[0][1][netif]['inet'][0].address %}
{%-   set publish_ip = grains.ip_interfaces[netif]|first %}
{%-   if salt['pillar.get']('hosting:external_redis', '') == '' %}
{%-     set redis_host = salt['mine.get']('G@roles:redis' + envmatch, 'network.interfaces', expr_form = 'compound').items()[0][1][netif]['inet'][0].address %}
{%-   else %}
{%-     set redis_host = salt['pillar.get']('hosting:external_redis') %}
{%-   endif %}

{%- endif %}

# Based on host settings, prepare cluster parameters for elasticsearch
{%- set es_total_nodes = (es_data_hosts)|count %}
{%- set es_minimum_nodes = ( es_total_nodes / 2 )|round|int %}

{%- if es_total_nodes > 1 %}
{%-   set es_replicas = 1 %}
{%-   set es_shards = 6 %}
{%- else %}
{%-   set es_replicas = 0 %}
{%-   set es_shards = 1 %}
{%- endif %}

# Combine settings from above into three directories, which can be easily
# imported from this state
{%- set elasticsearch = {} %}
{%- do elasticsearch.update ({
  'minimum_nodes'        : es_minimum_nodes,
  'total_nodes'          : es_total_nodes,
  'shards'               : es_shards,
  'replicas'             : es_replicas,
}) %}

{%- set host = {} %}
{%- do host.update ({
  'cron_master'          : cron_master_host,
  'queue'                : queue_host,
  'redis'                : redis_host,
}) %}

{%- set hosts = {} %}
{%- do hosts.update ({
  'app'                  : app_hosts,
  'web'                  : web_hosts,
  'job'                  : job_hosts,
  'elasticsearch_data'   : es_data_hosts,
  'elasticsearch_logs'   : es_log_hosts,
}) %}
