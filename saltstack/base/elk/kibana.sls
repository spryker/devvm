#
# Install Kibana
#

install-kibana:
  cmd.run:
    - name: cd /opt && wget -q https://download.elastic.co/kibana/kibana/kibana-{{ pillar.elk.kibana.version }}-linux-x64.tar.gz && tar zxf kibana-{{ pillar.elk.kibana.version }}-*.tar.gz && rm -f kibana-{{ pillar.elk.kibana.version }}-*.tar.gz && chown -R www-data. /opt/kibana-{{ pillar.elk.kibana.version }}-linux-x64
    - unless: test -d /opt/kibana-{{ pillar.elk.kibana.version }}-linux-x64

/opt/kibana:
  file.symlink:
    - target: /opt/kibana-{{ pillar.elk.kibana.version }}-linux-x64
    - require:
      - cmd: install-kibana

/opt/kibana/config/kibana.yml:
  file.managed:
    - source: salt://elk/files/opt/kibana/config/kibana.yml
    - template: jinja
    - require:
      - file: /opt/kibana
    - watch_in:
      - service: kibana

/etc/systemd/system/kibana.service:
  file.managed:
    - source: salt://elk/files/etc/systemd/system/kibana.service
    - template: jinja

kibana:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/kibana.service
      - file: /opt/kibana/config/kibana.yml
