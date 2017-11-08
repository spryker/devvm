#
# PHP Extensions:
#  - install extensions not provided by deb repositories
#  - configure extensions
#
{% from 'php/macros/php_module.sls' import php_module with context %}

# If pillar enables xdebug - install and configure it
{% if salt['pillar.get']('php:install_xdebug', False) %}
xdebug:
  pkg.installed:
    - name: php-xdebug

/etc/php/7.1/mods-available/xdebug.ini:
  file.managed:
    - source: salt://php/files/etc/php/7.1/mods-available/xdebug.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: xdebug

{{ php_module('xdebug', salt['pillar.get']('php:enable_xdebug', False), 'fpm') }}
{{ php_module('xdebug', salt['pillar.get']('php:enable_xdebug', False), 'cli') }}
{% endif %}


# Configure Zend OpCache extension
/etc/php/7.1/mods-available/opcache.ini:
  file.managed:
    - source: salt://php/files/etc/php/7.1/mods-available/opcache.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/php/7.1/cli/conf.d/05-opcache.ini:
  file.absent

/etc/php/7.1/fpm/conf.d/05-opcache.ini:
  file.absent

/var/lib/php/modules/7.1/cli/enabled_by_maint/opcache:
  file.absent

/var/lib/php/modules/7.1/fpm/enabled_by_maint/opcache:
  file.absent

{{ php_module('opcache', salt['pillar.get']('php:enable_opcache', True), 'fpm') }}
{{ php_module('opcache', salt['pillar.get']('php:enable_opcache', True), 'cli') }}
