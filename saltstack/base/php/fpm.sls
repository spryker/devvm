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

# VM-specific environments via systemd dropin via EnvironmentFile
/etc/systemd/system/php{{ salt['pillar.get']('php:major_version') }}-fpm.service.d/spryker-env.conf:
  file.managed:
    - makedirs: True
    - source: salt://php/files/etc/systemd/system/php{{ salt['pillar.get']('php:major_version') }}-fpm.service.d/spryker-env.conf
    - watch_in:
      - cmd: fpm-reload-systemd

# Make sure that the vm environment file exists (is at least empty) for systemd EnvironmentFile
/etc/spryker-vm-env:
  file.managed:
    - replace: False
    - content: ''
    - require_in:
      - cmd: fpm-reload-systemd

# Reload service on changes
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
