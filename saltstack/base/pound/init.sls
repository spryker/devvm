#
# Install and configure pound, and SSL-Termination proxy
#

/etc/apt/preferences
  file.managed:
    - source: salt://pound/files/repo.preferences

sid-repo:
  pkgrepo.managed:
    - name: deb http://deb.debian.org/debian/ unstable main contrib non-free
    - dist: unstable
    - enabled: False
    - refresh_db: False
    - require:
      - file: /etc/apt/preferences

#pound:
#  pkg.installed:
#    - name: pound
pound:
  pkg.installed:
    - fromrepo: sid
    - pkgs:
      - init-system-helpers
      - libc6
      - libc6.1
      - libmbedcrypto3
      - libmbedtls12
      - libmbedx509-0
      - libnanomsg5
      - libpcre3
      - libyaml-0-2
      - lsb-base
      - sysuser-helper
      - libnanomsg0
      - libnanomsg4
      - pound
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
