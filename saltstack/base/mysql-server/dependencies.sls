#
# Dependencies for salt for managing mysql resources
#

server_pkgs:
  pkg:
    - installed
    - pkgs:
      - python-dev
    - refresh: True

mysql_python_pkgs:
  pkg.installed:
    - pkgs:
      - libmariadb3-compat
      - libmariadb-dev-compat
      - libmariadb-dev
      - python-mysqldb
    - require:
      - pkg: server_pkgs

python-pip:
  pkg:
    - installed
    - refresh: False
