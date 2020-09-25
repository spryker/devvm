#
# Install Elasticsearch 6.8.6
#

install-elasticsearch6:
  cmd.run:
    - name: cd /opt && wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.8.6.tar.gz && tar zxf elasticsearch-6.8.6.tar.gz && rm -f elasticsearch-6.8.6.tar.gz && chown -R elasticsearch. /opt/elasticsearch-6.8.6
    - unless: test -d /opt/elasticsearch-6.8.6

/opt/elasticsearch-6.8.6/config:
  file.recurse:
    - source: salt://elasticsearch/files/elasticsearch6_instance/config
    - user: elasticsearch
    - group: elasticsearch
    - file_mode: 644
    - dir_mode: 755

/etc/systemd/system/elasticsearch6-{{ environment }}.service:
  file.managed:
    - source: salt://elasticsearch/files/elasticsearch6_instance/etc/systemd/system/elasticsearch6.service
    - template: jinja

/etc/default/elasticsearch6-{{ environment }}:
  file.managed:
    - source: salt://elasticsearch/files/elasticsearch6_instance/etc/default/elasticsearch6
    - mode: 644
    - user: root
    - group: root
    - template: jinja
