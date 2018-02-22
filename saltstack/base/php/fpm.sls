#
# General PHP-FPM configuration
#

# FPM global configuration file
/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/php-fpm.conf:
  file.managed:
    - source: salt://php/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/php-fpm.conf

# Remove the default pool
/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/pool.d/www.conf:
  file.absent

# Enable or disable FPM service
php{{ salt['pillar.get']('php:major_version') }}-fpm:
  service:
{#% if 'web' in grains.roles %#}
    - running
    - enable: True
{#% else %#}
#    - dead
#    - enable: False
{#% endif %#}
