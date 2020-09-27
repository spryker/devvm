#
# Install Kibana
#

install-kibana:
  cmd.run:
    - name: cd /opt && wget -q https://artifacts.elastic.co/downloads/kibana/kibana-6.8.6-linux-x86_64.tar.gz && tar zxf kibana-6.8.6-*.tar.gz && rm -f kibana-6.8.6-*.tar.gz && chown -R www-data. /opt/kibana-6.8.6-linux-x86_64
    - unless: test -d /opt/kibana-6.8.6-linux-x86_64

/opt/kibana6:
  file.symlink:
    - target: /opt/kibana-6.8.6-linux-x86_64
    - require:
      - cmd: install-kibana

/opt/kibana6/config/kibana.yml:
  file.managed:
    - source: salt://elk/files/opt/kibana6/config/kibana.yml
    - template: jinja
    - require:
      - file: /opt/kibana6


/etc/systemd/system/kibana6.service:
  file.managed:
    - source: salt://elk/files/etc/systemd/system/kibana6.service
    - template: jinja
