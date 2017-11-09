#
# Create postgresql databases, users and privileges
#
#
# This implementation at the moment is 'hacky', as on the day when it was
# written, salt did not support creating schemes and/or managing privileges.
# For each environment we create user and two databases (zed + dump), which
# have the owner set to this user.

# Create admin account, if configured in pillar
{%- if salt['pillar.get']('postgresql:superuser', False) %}
postgres_users_admin:
  postgres_user.present:
    - name: {{ pillar.postgresql.superuser.username }}
    - password: {{ pillar.postgresql.superuser.password }}
    - superuser: True
    - require:
      - service: postgresql
{%- endif %}

{%- from 'settings/init.sls' import settings with context %}
{%- for environment, environment_details in settings.environments.items() %}
{%- for store in pillar.stores %}

# create database user
postgres_users_{{ store }}_{{ environment }}:
  postgres_user.present:
    - name: {{ settings.environments[environment].stores[store].zed.database.username }}
    - password: {{ settings.environments[environment].stores[store].zed.database.password }}
    - require:
      - service: postgresql

# create database - zed
postgres_database_{{ store }}_{{ environment }}_zed:
  postgres_database.present:
    - name: {{ settings.environments[environment].stores[store].zed.database.database }}
    - owner: {{ settings.environments[environment].stores[store].zed.database.username }}
    - require:
      - service: postgresql
      - postgres_user: {{ settings.environments[environment].stores[store].zed.database.username }}

# Add citext extension to the database
postgres_database_citext_{{ store }}_{{ environment }}_zed:
  postgres_extension.present:
    - name: citext
    - maintenance_db: {{ settings.environments[environment].stores[store].zed.database.database }}
    - require:
      - postgres_database: postgres_database_{{ store }}_{{ environment }}_zed

# create database - dump
postgres_database_{{ store }}_{{ environment }}_zed_dump:
  postgres_database.present:
    - name: {{ settings.environments[environment].stores[store].dump.database.database }}
    - owner: {{ settings.environments[environment].stores[store].zed.database.username }}
    - require:
      - service: postgresql
      - postgres_user: {{ settings.environments[environment].stores[store].zed.database.username }}

postgres_database_citext_{{ store }}_{{ environment }}_zed_dump:
  postgres_extension.present:
    - name: citext
    - maintenance_db: {{ settings.environments[environment].stores[store].dump.database.database }}
    - require:
      - postgres_database: postgres_database_{{ store }}_{{ environment }}_zed_dump


{% endfor %}
{% endfor %}
