#
# Install and configure pound, and SSL-Termination proxy
#

experimental:
  pkgrepo.managed:
    - name: deb http://ftp.debian.org/debian experimental main contrib non-free

pound:
  pkg.installed:
    - fromrepo: experimental
    - refresh: False
#pound:
#  pkg.installed:
#    - name: pound
  service:
    - running
    - require:
      - pkg: pound
      - file: /etc/default/pound
      - file: /etc/pound/certs/1star_local
      - file: /etc/pound/certs/2star_local
      - file: /etc/pound/certs/3star_local
      - file: /etc/pound/certs/4star_local
      - file: /etc/pound/certs/star_spryker_dev
    - watch:
      - file: /etc/pound/pound.cfg

/etc/pound/pound.cfg:
  file.managed:
    - source: salt://pound/files/etc/pound/pound.cfg
    - require:
      - pkg: pound

/etc/default/pound:
  file.managed:
    - source: salt://pound/files/etc/default/pound
    - require:
      - pkg: pound

/etc/pound/certs:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: pound

/etc/pound/certs/1star_local:
  file.managed:
    - source: salt://pound/files/etc/pound/certs/1star_local
    - require:
      - file: /etc/pound/certs

/etc/pound/certs/2star_local:
  file.managed:
    - source: salt://pound/files/etc/pound/certs/2star_local
    - require:
      - file: /etc/pound/certs

/etc/pound/certs/3star_local:
  file.managed:
    - source: salt://pound/files/etc/pound/certs/3star_local
    - require:
      - file: /etc/pound/certs

/etc/pound/certs/4star_local:
  file.managed:
    - source: salt://pound/files/etc/pound/certs/4star_local
    - require:
      - file: /etc/pound/certs

/etc/pound/certs/star_spryker_dev:
  file.managed:
    - source: salt://pound/files/etc/pound/certs/star_spryker_dev
    - require:
      - file: /etc/pound/certs
