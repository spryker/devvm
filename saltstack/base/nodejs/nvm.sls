#
# Install NVM
#

https://github.com/creationix/nvm.git:
  git.latest:
    - rev: master
    - target: /opt/nvm
    - force: True

nvm_profile:
  file.blockreplace:
    - name: /etc/profile
    - marker_start: "#> Saltstack Managed Configuration NVM START <#"
    - marker_end: "#> Saltstack Managed Configuration NVM END <#"
    - append_if_not_found: true
    - content: |
        if [ -f "/opt/nvm/nvm.sh" ]; then
          source {{ install_path }}/nvm.sh
        fi