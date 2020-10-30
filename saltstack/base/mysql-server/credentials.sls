#
# Create MySQL databases, users and privileges
#

{%- from 'settings/init.sls' import settings with context %}
{%- for environment, environment_details in settings.environments.items() %}
{%- for store in pillar.stores %}

# create database - zed
mysql_database_{{ store }}_{{ environment }}_zed:
  mysql_database.present:
    - name: {{ settings.environments[environment].stores[store].zed.database.database }}
    - require:
      - pkg: python-mysqldb
{% if salt['pillar.get']('hosting:external_mysql', '') == '' %}
      - service: mysql
{% endif %}

# create database - dump
mysql_database_{{ store }}_{{ environment }}_zed_dump:
  mysql_database.present:
    - name: {{ settings.environments[environment].stores[store].dump.database.database }}
    - require:
      - pkg: python-mysqldb
{% if salt['pillar.get']('hosting:external_mysql', '') == '' %}
      - service: mysql
{% endif %}

