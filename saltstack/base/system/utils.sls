#
# Install utility debian packages
#

base-utilities:
  pkg.installed:
    - pkgs:
      - git
      - unzip
      - pbzip2
      - screen
      - mc
      - curl
      - lsof
      - htop
      - iotop
      - dstat
      - telnet
      - make
      - vim
      - nano
    - require:
      - cmd: apt-get-update

git:
  pkg.installed:
    - fromrepo: git-repo
