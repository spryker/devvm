#
# Install and configure local MySQL server for development / QA
# For production setup, a high-available solution or DBaaS (database-as-a-service) should be used
#

mysql-server:
  pkg.installed:
    - pkgs:
      - mysql-community-server
      - mysql-community-client
      - libmysqlclient20

mysql:
  service.running:
    - enable: True
    - watch:
      - pkg: mysql-server
      - file: /etc/mysql/my.cnf

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://mysql-server/files/etc/mysql/my.cnf
    - template: jinja

/etc/mysql/conf.d/strict.cnf:
  file.managed:
    - source: salt://mysql-server/files/etc/mysql/conf.d/strict.cnf
