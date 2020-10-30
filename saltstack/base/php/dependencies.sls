#
# Dependency packages for php extenstions
#

{% set mysql_client_libs_package_name = {
    'stretch': 'libmariadbd19',
    'wheezy':  'libmysqlclient18',
    'jessie':  'libmysqlclient18',
}.get(grains.lsb_distrib_codename) %}

php-extension-dependencies:
  pkg.installed:
    - pkgs:
      - pkg-config
      - mariadb.common
      - {{ mysql_client_libs_package_name }}

