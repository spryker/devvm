#
# Set php.ini configuration files
#

# Web apps (FPM)
/etc/php/{{ salt['pillar.get']('php:major_version') }}/fpm/php.ini:
  file.managed:
    - source: salt://php/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/php.ini
    - require:
      - pkg: php

# CLI
/etc/php/{{ salt['pillar.get']('php:major_version') }}/cli/php.ini:
  file.managed:
    - source: salt://php/files/etc/php/{{ salt['pillar.get']('php:major_version') }}/php.ini
    - require:
      - pkg: php
