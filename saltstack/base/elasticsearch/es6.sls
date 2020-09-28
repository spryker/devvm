#
# Install Elasticsearch 6.8.6 as the second service
#

install-elasticsearch6:
  cmd.run:
    - name: cd /opt && wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.8.6.tar.gz && tar zxf elasticsearch-6.8.6.tar.gz && rm -f elasticsearch-6.8.6.tar.gz && chown -R elasticsearch. /opt/elasticsearch-6.8.6 && rm -rf /opt/elasticsearch-6.8.6/config/*
    - unless: test -d /opt/elasticsearch-6.8.6

/opt/elasticsearch-6.8.6/config:
  file.recurse:
    - source: salt://elasticsearch/files/es6_instance/config
    - user: elasticsearch
    - group: elasticsearch
    - file_mode: 644
    - dir_mode: 755

/etc/systemd/system/elasticsearch6-development.service:
  file.managed:
    - source: salt://elasticsearch/files/es6_instance/etc/systemd/system/elasticsearch6.service
    - mode: 644
    - user: root
    - group: root

/etc/default/elasticsearch6-development:
  file.managed:
    - source: salt://elasticsearch/files/es6_instance/etc/default/elasticsearch6
    - mode: 644
    - user: root
    - group: root

/home/vagrant/es6.sh:
  file.managed:
    - source: salt://elasticsearch/files/es6_instance/es6.sh
    - mode: 744
    - user: root
    - group: root

/home/vagrant/es7.sh:
  file.managed:
    - source: salt://elasticsearch/files/es6_instance/es7.sh
    - mode: 744
    - user: root
    - group: root
