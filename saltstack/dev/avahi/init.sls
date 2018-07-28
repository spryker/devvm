#
# Tools and settings for local file sharing discovery on Mac
#

install-avahi:
  pkg.installed:
    - name: avahi-daemon

/etc/avahi/avahi-daemon.conf:
  file.managed:
    - source: salt://avahi/files/etc/avahi/avahi-daemon.conf
    - require:
      - pkg: install-avahi

/etc/avahi/services/smb.conf:
  file.managed:
    - source: salt://avahi/files/etc/avahi/services/smb.conf
    - require:
      - pkg: install-avahi

avahi-daemon:
  service.running:
    - enable: True
    - require:
      - pkg: install-avahi
    - watch:
      - file: /etc/avahi/avahi-daemon.conf
      - file: /etc/avahi/services/smb.conf
