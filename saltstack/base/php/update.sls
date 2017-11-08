#
# Update PHP package
#
# Note: this state is included only if pillar setting autoupdate:php is true

# Update php packages. We have to specify here php7.1, php7.1-common (to force
# upgrading php extensions installed via debian packages) and php7.1-fpm
# (to workaround debian package system installing libapache2-mod-php7.1)
update-php:
  pkg.latest:
    - pkgs:
      - php7.1-fpm
      - php7.1-common
      - php7.1-dev
