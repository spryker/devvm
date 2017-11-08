#
# Install PHP and modules available from operating system distribution
#

php:
  pkg.installed:
    - pkgs:
      - php7.1-dev
      - php7.1-bcmath
      - php7.1-bz2
      - php7.1-cli
      - php7.1-fpm
      - php7.1-curl
      - php7.1-gd
      - php7.1-gmp
      - php7.1-intl
      - php7.1-mbstring
      - php7.1-mcrypt
      - php7.1-mysql
      - php7.1-pgsql
      - php7.1-sqlite3
      - php7.1-xml
      - php7.1-opcache
      - php-igbinary
      - php-imagick
      - php-memcached
      - php-msgpack
      - php-redis
      - php-ssh2
      
