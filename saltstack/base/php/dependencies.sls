#
# Dependency packages for php extenstions
#

{% set mysql_client_libs_package_name = {
    'buster': 'libmariadbclient-dev-compat',
    'stretch': 'libmariadbclient18',
    'wheezy':  'libmysqlclient18',
    'jessie':  'libmysqlclient18',
}.get(grains.lsb_distrib_codename) %}

php-extension-dependencies:
  pkg.installed:
    - pkgs:
      - mariadb-common
      - {{ mysql_client_libs_package_name }}
  #    - pkg-config
