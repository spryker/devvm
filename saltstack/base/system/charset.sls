/etc/profile.d/fix_charset.sh:
  file.managed:
    - source: salt://system/files/etc/profile.d/fix_charset.sh
    - user: root
    - group: root
    - mode: 644

