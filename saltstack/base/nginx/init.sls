#
# Install NginX webserver, setup global configuration
#

# Install package and setup service
install-nginx:
  pkg.installed:
    - pkgs:
      - nginx-extras
      - libnginx-mod-http-headers-more-filter

nginx:
  service.running:
    - require:
      - pkg: install-nginx
    - watch:
      - file: /etc/nginx/nginx.conf

# Apache Utilities - for tools like ab, htpasswd
apache2-utils:
  pkg.installed

# Main nginx configurationf file
/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/files/etc/nginx/nginx.conf
    - template: jinja
    - require:
      - pkg: install-nginx

# Global includes
/etc/nginx/conf.d:
  file.recurse:
    - source: salt://nginx/files/etc/nginx/conf.d
    - template: jinja
    - require:
      - pkg: install-nginx
    - watch_in:
      - service: nginx

# FastCGI parameters
/etc/nginx/fastcgi_params:
  file.managed:
    - source: salt://nginx/files/etc/nginx/fastcgi_params
    - require:
      - pkg: install-nginx
    - watch_in:
      - service: nginx

# Create directory for SSL certificates
/etc/nginx/ssl:
  file.directory:
    - user: root
    - group: www-data
    - mode: 640
    - require:
      - pkg: install-nginx

# Delete default vhost
/etc/nginx/sites-enabled/default:
  file.absent:
    - require:
      - pkg: install-nginx
    - watch_in:
      - service: nginx
