#
# Dependency packages for php extensions
#

{% set mysql_client_libs_package_name = {
    'buster': 'libmariadbclient18',
    'stretch': 'libmariadbclient18',
    'wheezy':  'libmysqlclient18',
    'jessie':  'libmysqlclient18',
}.get(grains.lsb_distrib_codename) %}

php-extension-dependencies:
  pkg.installed:
    - pkgs:
      - pkg-config
      - mariadb-common
      - {{ mysql_client_libs_package_name }}
