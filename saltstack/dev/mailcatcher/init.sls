#
# Install mailcatcher - http://mailcatcher.me/
#
# MailCatcher runs a super simple SMTP server which catches any message sent to it to display in a web interface.
# Mails delivered via smtp to 127.0.0.1:1025 will be visible in web browser on http://127.0.0.1:1080

libsqlite3-dev:
  pkg.installed:
    - require_in:
      - gem: mailcatcher

mailcatcher:
  gem.installed

mailcatcher-systemd-script:
  file.managed:
    - name: /etc/systemd/system/mailcatcher.service
    - mode: 0755
    - source: salt://mailcatcher/files/etc/systemd/system/mailcatcher.service
    - watch_in:
      - cmd: mailcatcher-systemd-reload

mailcatcher-systemd-reload:
  cmd.wait:
    - name: systemctl daemon-reload

mailcatcher-service:
  service.running:
    - name: mailcatcher
    - enable: True
    - require:
      - file: mailcatcher-systemd-script
      - gem: mailcatcher
      - cmd: mailcatcher-systemd-reload
