#
# Install PHP and modules available from operating system distribution
#

php:
  pkg.installed:
    - pkgs:
      - php{{ salt['pillar.get']('php:major_version') }}-dev
      - php{{ salt['pillar.get']('php:major_version') }}-bcmath
      - php{{ salt['pillar.get']('php:major_version') }}-bz2
      - php{{ salt['pillar.get']('php:major_version') }}-cli
      - php{{ salt['pillar.get']('php:major_version') }}-fpm
      - php{{ salt['pillar.get']('php:major_version') }}-curl
      - php{{ salt['pillar.get']('php:major_version') }}-gd
      - php{{ salt['pillar.get']('php:major_version') }}-gmp
      - php{{ salt['pillar.get']('php:major_version') }}-intl
      - php{{ salt['pillar.get']('php:major_version') }}-mbstring
      - php{{ salt['pillar.get']('php:major_version') }}-mysql
      - php{{ salt['pillar.get']('php:major_version') }}-pgsql
      - php{{ salt['pillar.get']('php:major_version') }}-sqlite3
      - php{{ salt['pillar.get']('php:major_version') }}-xml
      - php{{ salt['pillar.get']('php:major_version') }}-zip
      - php{{ salt['pillar.get']('php:major_version') }}-opcache
      - php-igbinary
      - php-imagick
      - php-memcached
      - php-msgpack
      - php-redis
      - php-ssh2
