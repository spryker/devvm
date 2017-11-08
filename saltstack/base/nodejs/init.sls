#
# Install NodeJS and Yarn package manager
#

nodejs:
  pkg.installed

yarn:
  pkg.installed

# Include autoupdate if configured to do so
{% if salt['pillar.get']('autoupdate:nodejs', False) %}
include:
  - .update
{% endif %}
