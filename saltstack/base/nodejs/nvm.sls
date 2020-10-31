#
# Install NVM
#

/opt/nvm:
  file.directory:
    - user: vagrant
    - group: vagrant

https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh:
  git.latest:
    - rev: master
    - target: /opt/nvm
    - user: vagrant
    - require:
      - file: /opt/nvm

nvm_profile:
  file.blockreplace:
    - name: /etc/profile
    - marker_start: "#> Saltstack Managed Configuration NVM START <#"
    - marker_end: "#> Saltstack Managed Configuration NVM END <#"
    - append_if_not_found: true
    - content: |
        if [ -f "/opt/nvm/nvm.sh" ]; then
          source /opt/nvm/nvm.sh
        fi
