#
# Tools and settings for local development
#

install-cachefilesd:
  pkg.installed:
    - name: cachefilesd

/etc/default/cachefilesd:
  file.managed:
    - source: salt://cachefilesd/files/etc/default/cachefilesd
    - require:
      - pkg: install-cachefilesd

cachefilesd:
  service.running:
    - enable: True
    - require:
      - pkg: install-cachefilesd
      - file: /etc/default/cachefilesd
    - watch:
      - file: /etc/default/cachefilesd
    - check_cmd:
      - /bin/true
