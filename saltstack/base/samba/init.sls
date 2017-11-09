#
# Setup samba for reversed option of sharing. This is optional.
#

install-smb-server:
  pkg.installed:
    - name: samba

/etc/samba/smb.conf:
  file.managed:
    - source: salt://samba/files/etc/samba/smb.conf
    - require:
      - pkg: install-smb-server

samba:
  service.dead:
    - enable: False
    - require:
      - pkg: install-smb-server
      - file: /etc/samba/smb.conf
    - watch:
      - file: /etc/samba/smb.conf
