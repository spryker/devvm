#
# Dependencies for salt for managing mysql resources
#

server_pkgs:
  pkg.installed:
    - pkgs:
      - python-dev
      - python-psutil
    - refresh: True

mysql_python_pkgs:
  pkg.installed:
    - pkgs:
      - libmariadb3-compat
      - libmariadb-dev-compat
      - libmariadb-dev
      - mariadb-common
      - mysql-common
      - python-mysqldb
    - require:
      - pkg: server_pkgs

python-pip:
  pkg:
    - installed
    - refresh: False
