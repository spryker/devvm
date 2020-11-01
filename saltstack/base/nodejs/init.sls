#
# Install NodeJS and Yarn package manager
#

python-psutil:
  pkg.installed

nodejs:
  pkg.installed:
    - require:
      - pkg: python-psutil

yarn:
  pkg.installed

include:
  - .nvm
# Include autoupdate if configured to do so
{% if salt['pillar.get']('autoupdate:nodejs', False) %}
  - .update
{% endif %}
