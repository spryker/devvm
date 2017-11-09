#
# Install Ruby and used gems
#

{% set ruby_package_name = {
    'stretch': 'ruby',
    'wheezy':  'ruby1.9.1',
    'jessie':  'ruby',
}.get(grains.lsb_distrib_codename) %}

ruby:
  pkg.installed:
    - pkgs:
      - {{ ruby_package_name }}
      - ruby-dev
      - libncurses5-dev
      - build-essential

compass:
  gem.installed

psych:
  gem.installed

highline:
  gem.installed:
    - require:
      - gem: psych


# Install fixed versions, as the 2.8.0+ had problems with changed packet sizes
net-ssh:
  gem.installed:
    - version: 2.7.0

net-scp:
  gem.installed:
    - version: 1.1.2

net-ssh-multi:
  gem.installed:
    - version: 1.2.0
