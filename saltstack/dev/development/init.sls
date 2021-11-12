#
# Tools and settings for local development
#

# Performance tuning for samba client
/etc/modprobe.d/cifs.conf:
  file.managed:
    - source: salt://development/files/etc/modprobe.d/cifs.conf

# Pre-fetch SSH key for git repository
get-github-ssh-hostkey:
  cmd.run:
    - name: ssh-keyscan -H {{ pillar.deploy.git_hostname }} >> /home/vagrant/.ssh/known_hosts
    - unless: test -f /home/vagrant/.ssh/known_hosts
    - runas: vagrant

/home/vagrant/bin:
  file.recurse:
    - source: salt://development/files/home/vagrant/bin
    - user: vagrant
    - group: vagrant
    - template: jinja
    - file_mode: 755
    - dir_mode: 755

# Manually sync host to Vagrant Host
/etc/cron.d/vagrant-ntpdate:
  file.managed:
    - source: salt://development/files/etc/cron.d/vagrant-ntpdate

# Assign user to www-data group
vagrant-user:
  user.present:
    - name: vagrant
    - gid: www-data
    - allow_gid_change: True
