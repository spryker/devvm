#
# Setup Spryker environments
#

{% from 'settings/init.sls' import settings with context %}
{% from 'spryker/macros/jenkins_instance.sls' import jenkins_instance with context %}

{%- for environment, environment_details in pillar.environments.items() %}
/data/shop/{{ environment }}:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - require:
      - file: /data/shop

/data/shop/{{ environment }}/shared:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - require:
      - file: /data/shop/{{ environment }}

# Create environment directory structure
/data/shop/{{ environment }}/shared/Generated:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 755
    - require:
      - file: /data/shop/{{ environment }}/shared

/data/shop/{{ environment }}/shared/data/common:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 755
    - makedirs: True
    - require:
      - file: /data/shop/{{ environment }}/shared

/data/logs/{{ environment }}:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - file_mode: 755
    - require:
      - file: /data/logs

# If we do not use cloud object storage, then this directory should be shared
# between servers (using technology like NFS or GlusterFS, not included here).
/data/shop/{{ environment }}/shared/data/static:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - require:
      - file: /data/shop/{{ environment }}/shared/data/common

# Application environment config
/data/shop/{{ environment }}/shared/config_local.php:
  file.managed:
    - source: salt://spryker/files/config/config_local.php
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 644
    - require:
      - file: /data/shop/{{ environment }}/shared/data/common
    - context:
      environment: {{ environment }}
      settings: {{ settings|tojson }}

/data/shop/{{ environment }}/shared/console_env_local.php:
  file.managed:
    - source: salt://spryker/files/config/console_env_local.php
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 644
    - require:
      - file: /data/shop/{{ environment }}/shared/data/common
    - context:
      environment: {{ environment }}
      settings: {{ settings|tojson }}

{%- if 'code_symlink' in environment_details %}
/data/shop/{{ environment }}/current:
  file.symlink:
    - target: {{ environment_details.code_symlink }}
{%- endif %}

{%- if ('web' in salt['grains.get']('roles', [])) or (salt['grains.get']('role', '') in ['spryker_single_host']) %}
# Configure PHP-FPM pools
/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/pool.d/{{ environment }}-zed.conf:
  file.managed:
    - source: salt://spryker/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/pool.d/zed.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - cmd: reload-php-fpm
    - context:
      environment: {{ environment }}

/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/pool.d/{{ environment }}-yves.conf:
  file.managed:
    - source: salt://spryker/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/pool.d/yves.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - cmd: reload-php-fpm
    - context:
      environment: {{ environment }}

/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/pool.d/{{ environment }}-glue.conf:
  file.managed:
    - source: salt://spryker/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/pool.d/glue.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - cmd: reload-php-fpm
    - context:
      environment: {{ environment }}

# NginX configs
/etc/nginx/conf.d/{{ environment }}-backend.conf:
  file.managed:
    - source: salt://spryker/files/etc/nginx/conf.d/backend.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - cmd: reload-nginx
    - context:
      environment: {{ environment }}

# Local NginX static vhost for images/assets?
{% if 'enable_local_vhost' in environment_details.static %}
{% if environment_details.static.enable_local_vhost %}
/etc/nginx/sites-available/{{ environment }}_static:
  file.managed:
    - source: salt://spryker/files/etc/nginx/sites-available/static.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      environment: {{ environment }}
      settings: {{ settings|tojson }}
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-enabled/{{ environment }}_static:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ environment }}_static
    - force: true
    - require:
      - file: /etc/nginx/sites-available/{{ environment }}_static
    - watch_in:
      - cmd: reload-nginx
{%- endif %}
{%- endif %}

{%- endif %}

{%- if 'cronjobs' in grains.roles %}
{{ jenkins_instance(environment, environment_details, settings) }}
{%- endif %}

{%- endfor %}
