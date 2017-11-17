#
# Populate NginX configuration includes, used in VHost definitions.
#

{%- if ('web' in salt['grains.get']('roles', [])) or (salt['grains.get']('role', '') in ['spryker_single_host'] %}
/etc/nginx/spryker:
  file.recurse:
    - source: salt://spryker/files/etc/nginx/spryker
    - watch_in:
      - cmd: reload-nginx
{% endif %}
