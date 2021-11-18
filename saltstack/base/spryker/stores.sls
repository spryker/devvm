
{% from 'settings/init.sls' import settings with context %}

{%- for environment, environment_details in settings.environments.items() %}
{%- for store in pillar.stores %}

# Generate application store config - config_local_XX.php
/data/shop/{{ environment }}/shared/config_local_{{ store }}.php:
  file.managed:
    - source: salt://spryker/files/config/config_local_XX.php
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 644
    - require:
      - file: /data/shop/{{ environment }}/shared/data/common
    - context:
      environment: {{ environment }}
      store: {{ store }}
      settings: {{ settings|tojson }}

# Create logs directory for environment
/data/logs/{{ environment }}/{{ store }}:
  file.symlink:
    - target: /data/shop/{{ environment }}/current/data/{{ store }}/logs
    - force: True

{%- if 'web' in grains.roles %}
# Only on webservers: create nginx vhosts
/etc/nginx/sites-available/{{ store }}_{{ environment }}_zed:
  file.managed:
    - source: salt://spryker/files/etc/nginx/sites-available/XX-zed.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      environment: {{ environment }}
      store: {{ store }}
      settings: {{ settings|tojson }}
    - require:
      - file: /data/logs/{{ environment }}
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-available/{{ store }}_{{ environment }}_yves:
  file.managed:
    - source: salt://spryker/files/etc/nginx/sites-available/XX-yves.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      environment: {{ environment }}
      store: {{ store }}
      settings: {{ settings|tojson }}
    - require:
      - file: /data/logs/{{ environment }}
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-available/{{ store }}_{{ environment }}_glue:
  file.managed:
    - source: salt://spryker/files/etc/nginx/sites-available/XX-glue.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      environment: {{ environment }}
      store: {{ store }}
      settings: {{ settings|tojson }}
    - require:
      - file: /data/logs/{{ environment }}
    - watch_in:
      - cmd: reload-nginx

# adding new endpoints
/etc/nginx/sites-available/{{ store }}_{{ environment }}_gateway:
  file.managed:
    - source: salt://spryker/files/etc/nginx/sites-available/XX-gateway.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      environment: {{ environment }}
      store: {{ store }}
      settings: {{ settings|tojson }}
    - require:
      - file: /data/logs/{{ environment }}
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-available/{{ store }}_{{ environment }}_backoffice:
  file.managed:
    - source: salt://spryker/files/etc/nginx/sites-available/XX-backoffice.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      environment: {{ environment }}
      store: {{ store }}
      settings: {{ settings|tojson }}
    - require:
      - file: /data/logs/{{ environment }}
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-available/{{ store }}_{{ environment }}_backendgateway:
  file.managed:
    - source: salt://spryker/files/etc/nginx/sites-available/XX-backendgateway.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      environment: {{ environment }}
      store: {{ store }}
      settings: {{ settings|tojson }}
    - require:
      - file: /data/logs/{{ environment }}
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-available/{{ store }}_{{ environment }}_backendapi:
  file.managed:
    - source: salt://spryker/files/etc/nginx/sites-available/XX-backendapi.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      environment: {{ environment }}
      store: {{ store }}
      settings: {{ settings|tojson }}
    - require:
      - file: /data/logs/{{ environment }}
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-available/{{ store }}_{{ environment }}_glue-storefront:
  file.managed:
    - source: salt://spryker/files/etc/nginx/sites-available/XX-glue-storefront.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      environment: {{ environment }}
      store: {{ store }}
      settings: {{ settings|tojson }}
    - require:
      - file: /data/logs/{{ environment }}
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-available/{{ store }}_{{ environment }}_glue-backend:
  file.managed:
    - source: salt://spryker/files/etc/nginx/sites-available/XX-glue-backend.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      environment: {{ environment }}
      store: {{ store }}
      settings: {{ settings|tojson }}
    - require:
      - file: /data/logs/{{ environment }}
    - watch_in:
      - cmd: reload-nginx

#end of adding new endpoints

/etc/nginx/sites-enabled/{{ store }}_{{ environment }}_zed:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ store }}_{{ environment }}_zed
    - force: true
    - require:
      - file: /etc/nginx/sites-available/{{ store }}_{{ environment }}_zed
      - file: /etc/nginx/htpasswd-zed
      - file: /etc/nginx/htpasswd-staging
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-enabled/{{ store }}_{{ environment }}_yves:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ store }}_{{ environment }}_yves
    - force: true
    - require:
      - file: /etc/nginx/sites-available/{{ store }}_{{ environment }}_yves
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-enabled/{{ store }}_{{ environment }}_glue:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ store }}_{{ environment }}_glue
    - force: true
    - require:
      - file: /etc/nginx/sites-available/{{ store }}_{{ environment }}_glue
    - watch_in:
      - cmd: reload-nginx

#add new endpoints 
/etc/nginx/sites-enabled/{{ store }}_{{ environment }}_gateway:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ store }}_{{ environment }}_gateway
    - force: true
    - require:
      - file: /etc/nginx/sites-available/{{ store }}_{{ environment }}_gateway
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-enabled/{{ store }}_{{ environment }}_backoffice:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ store }}_{{ environment }}_backoffice
    - force: true
    - require:
      - file: /etc/nginx/sites-available/{{ store }}_{{ environment }}_backoffice
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-enabled/{{ store }}_{{ environment }}_backendgateway:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ store }}_{{ environment }}_backendgateway
    - force: true
    - require:
      - file: /etc/nginx/sites-available/{{ store }}_{{ environment }}_backendgateway
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-enabled/{{ store }}_{{ environment }}_backendapi:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ store }}_{{ environment }}_backendapi
    - force: true
    - require:
      - file: /etc/nginx/sites-available/{{ store }}_{{ environment }}_backendapi
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-enabled/{{ store }}_{{ environment }}_glue-storefront:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ store }}_{{ environment }}_glue-storefront
    - force: true
    - require:
      - file: /etc/nginx/sites-available/{{ store }}_{{ environment }}_glue-storefront
    - watch_in:
      - cmd: reload-nginx

/etc/nginx/sites-enabled/{{ store }}_{{ environment }}_glue-backend:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ store }}_{{ environment }}_glue-backend
    - force: true
    - require:
      - file: /etc/nginx/sites-available/{{ store }}_{{ environment }}_glue-backend
    - watch_in:
      - cmd: reload-nginx

#end of adding new endpoints

{%- endif %}

{%- endfor %}
{%- endfor %}
