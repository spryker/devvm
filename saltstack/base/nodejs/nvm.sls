#
# Install NVM
#

/opt/nvm:
  file.directory:
    - user: vagrant
    - group: vagrant

# Run git manually because of a bug: https://github.com/saltstack/salt/issues/54817
clone-nvm:
  cmd.run:
    - name: git clone https://github.com/nvm-sh/nvm.git /opt/nvm
    - unless: test -d /opt/nvm
    - runas: vagrant

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
