#
# Install NodeJS and Yarn package manager
#

python3-psutil:
  pkg.installed

nodejs:
  pkg.installed:
    - require:
      - pkg: python3-psutil

yarn:
  pkg.installed

include:
  - .nvm
# Include autoupdate if configured to do so
{% if salt['pillar.get']('autoupdate:nodejs', False) %}
  - .update
{% endif %}
