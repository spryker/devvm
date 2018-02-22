#
# Update PHP package
#
# Note: this state is included only if pillar setting autoupdate:php is true

# Update php packages. We have to specify here phpX.X, phpX.X-common (to force
# upgrading php extensions installed via debian packages) and phpX.X-fpm
# (to workaround debian package system installing libapache2-mod-phpX.X)
update-php:
  pkg.latest:
    - pkgs:
      - php{{ salt['pillar.get']('php:major_version') }}-fpm
      - php{{ salt['pillar.get']('php:major_version') }}-common
      - php{{ salt['pillar.get']('php:major_version') }}-dev
