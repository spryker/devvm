#
# Install NVM
#

/opt/nvm:
  file.directory:
    - user: vagrant
    - group: vagrant

# Salt git bug fix: https://github.com/saltstack/salt/issues/54817
git_config_fixing:
  git.config_set:
    - name: [filter "lfs"]
    - global: True
    - require:
      - pkg: git
git_config_fixing_2:
  git.config_set:
    - name: clean
    - value: ""
    - global: True
    - require:
      - pkg: git

https://github.com/nvm-sh/nvm.git:
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
