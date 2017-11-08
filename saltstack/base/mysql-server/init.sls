#
# Prepare local development MySQL server
#

include:
{%- if salt['pillar.get']('hosting:external_mysql', '') == '' %}
  - .setup
{%- endif %}
  - .dependencies
  - .credentials
# Include autoupdate if configured to do so
{%- if salt['pillar.get']('hosting:external_mysql', '') == '' %}
{%- if salt['pillar.get']('autoupdate:mysql', False) %}
  - .update
{%- endif %}
{%- endif %}
