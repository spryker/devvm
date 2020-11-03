#
# Dependencies for salt for managing mysql resources
#

python_pkgs:
  pkg.installed:
    - pkgs:
      - python-dev
      - python-psutil
    - refresh: True

mysql_pkgs:
  pkg.installed:
    - pkgs:
      - libmariadb3-compat
      - libmariadb-dev-compat
      - libmariadb-dev
      - python-mysqldb
    - require:
      - pkg: python_pkgs
