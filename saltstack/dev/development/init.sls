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

# Install / Configure Oh-My-Zsh for user vagrant
clone-oh-my-zsh:
  cmd.run:
    - name: git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
    - unless: test -d /home/vagrant/.oh-my-zsh
    - runas: vagrant

# Create inital .zshrc, allow editing it by user (don't replace contents)
/home/vagrant/.zshrc:
  file.managed:
    - source: salt://development/files/home/vagrant/.zshrc
    - user: vagrant
    - group: vagrant
    - mode: 600
    - replace: False

/home/vagrant/.zsh_prompt:
  file.managed:
    - source: salt://development/files/home/vagrant/.zsh_prompt
    - user: vagrant
    - group: vagrant
    - mode: 644
    - replace: False

/home/vagrant/.zlogin:
  file.managed:
    - source: salt://development/files/home/vagrant/.zlogin
    - user: vagrant
    - group: vagrant
    - mode: 600
    - replace: False

/home/vagrant/bin:
  file.recurse:
    - source: salt://development/files/home/vagrant/bin
    - user: vagrant
    - group: vagrant
    - template: jinja
    - file_mode: 755
    - dir_mode: 755

/home/vagrant/.oh-my-zsh/custom/plugins/spryker:
  file.recurse:
    - source: salt://development/files/home/vagrant/oh-my-zsh/custom/plugins/spryker
    - user: vagrant
    - group: vagrant
    - file_mode: 600
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
