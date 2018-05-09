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

# VM-specific environments via systemd dropin
/etc/systemd/system/php{{ salt['pillar.get']('php:major_version') }}-fpm.service.d/spryker-env.conf:
  file.managed:
    - makedirs: True
    - source: salt://php/files/etc/systemd/system/php{{ salt['pillar.get']('php:major_version') }}-fpm.service.d/spryker-env.conf
    - watch_in:
      - cmd: fpm-reload-systemd

fpm-reload-systemd:
  cmd.wait:
    - name: systemctl daemon-reload

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
