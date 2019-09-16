#
# PHP Extensions:
#  - install extensions not provided by deb repositories
#  - configure extensions
#
{% from 'php/macros/php_module.sls' import php_module with context %}

#
# If pillar enables xdebug - install and configure it
#
{% if salt['pillar.get']('php:install_xdebug', False) %}
xdebug:
  pkg.installed:
    - name: php-xdebug

/etc/php/{{ salt['pillar.get']('php:major_version') }}/mods-available/xdebug.ini:
  file.managed:
    - source: salt://php/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/mods-available/xdebug.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: xdebug

{{ php_module('xdebug', salt['pillar.get']('php:enable_xdebug', False), 'fpm') }}
{{ php_module('xdebug', salt['pillar.get']('php:enable_xdebug', False), 'cli') }}
{% endif %}

#
# Configure Zend OpCache extension
#

/etc/php/{{ salt['pillar.get']('php:major_version') }}/mods-available/opcache.ini:
  file.managed:
    - source: salt://php/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/mods-available/opcache.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/php/{{ salt['pillar.get']('php:major_version') }}/cli/conf.d/05-opcache.ini:
  file.absent

/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/conf.d/05-opcache.ini:
  file.absent

/var/lib/php/modules/{{ salt['pillar.get']('php:major_version') }}/cli/enabled_by_maint/opcache:
  file.absent

/var/lib/php/modules/{{ salt['pillar.get']('php:major_version') }}/fpm/enabled_by_maint/opcache:
  file.absent

/var/tmp/opcache:
  file.directory:
    - user: root
    - group: root
    - mode: 1777

{{ php_module('opcache', salt['pillar.get']('php:enable_opcache', True), 'fpm') }}
{{ php_module('opcache', salt['pillar.get']('php:enable_opcache', True), 'cli') }}

#
# Configure sqlsrv and pdo_sqlsrv
#
/etc/php/{{ salt['pillar.get']('php:major_version') }}/mods-available/sqlsrv.ini:
  file.managed:
    - source: salt://php/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/mods-available/sqlsrv.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/php/{{ salt['pillar.get']('php:major_version') }}/cli/sqlsrv.ini:
  file.managed:
    - source: salt://php/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/cli/conf.d/sqlsrv.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/php/{{ salt['pillar.get']('php:major_version') }}/mods-available/pdo_sqlsrv.ini:
  file.managed:
    - source: salt://php/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/mods-available/pdo_sqlsrv.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/php/{{ salt['pillar.get']('php:major_version') }}/cli/pdo_sqlsrv.ini:
  file.managed:
    - source: salt://php/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/cli/conf.d/pdo_sqlsrv.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 644

