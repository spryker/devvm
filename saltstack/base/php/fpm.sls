#
# General PHP-FPM configuration
#

# FPM global configuration file
/etc/php/7.1/fpm/php-fpm.conf:
  file.managed:
    - source: salt://php/files/etc/php/7.1/fpm/php-fpm.conf

# Remove the default pool
/etc/php/7.1/fpm/pool.d/www.conf:
  file.absent

# Enable or disable FPM service
php7.1-fpm:
  service:
{#% if 'web' in grains.roles %#}
    - running
    - enable: True
{#% else %#}
#    - dead
#    - enable: False
{#% endif %#}
