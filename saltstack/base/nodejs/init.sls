#
# Install NodeJS and Yarn package manager
#

nodejs:
  pkg.installed

yarn:
  pkg.installed

include:
  - .nvm
# Include autoupdate if configured to do so
{% if salt['pillar.get']('autoupdate:nodejs', False) %}
  - .update
{% endif %}
