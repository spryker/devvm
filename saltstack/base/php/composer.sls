#
# Download composer
#

download-composer:
  cmd.run:
    - name: curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    - unless: test -f /usr/local/bin/composer
    - require:
      - pkg: php
