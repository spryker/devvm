#
# Install and configure pound, and SSL-Termination proxy
#

pound-depth:
  pkg.installed:
    - pkgs:
      - sysuser-helper
      - libmbedcrypto3
      - libmbedtls12
      - libmbedx509-0
      - libnanomsg5

#install-pound:
#  cmd.run:
#    - name: cd /opt && wget -q http://archive.ubuntu.com/ubuntu/pool/universe/p/pound/pound_3.0-1_amd64.deb && dpkg -i pound_3.0-1_amd64.deb && rm -f pound_3.0-1_amd64.deb
#    - require:
#      - pkg: pound-depth

install-pound:
  pkg.installed:
    - hold: True
    - sources:
      - jenkins: http://archive.ubuntu.com/ubuntu/pool/universe/p/pound/pound_3.0-1_amd64.deb
    - require:
      - pkg: pound-depth

pound:
  service:
    - running
    - require:
      - pkg: install-pound
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
      - pkg: install-pound

/etc/default/pound:
  file.managed:
    - source: salt://pound/files/etc/default/pound
    - require:
      - pkg: install-pound

/etc/pound/certs:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: install-pound

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
