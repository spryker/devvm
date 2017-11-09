#
# Set php.ini configuration files
#

# Web apps (FPM)
/etc/php/7.1/fpm/php.ini:
  file.managed:
    - source: salt://php/files/etc/php/7.1/php.ini
    - require:
      - pkg: php

# CLI
/etc/php/7.1/cli/php.ini:
  file.managed:
    - source: salt://php/files/etc/php/7.1/php.ini
    - require:
      - pkg: php
