#
# Install docker-engine, docker-compose
#

docker.io:
  pkg.removed

install-docker:
  pkg.installed:
    - name: docker-ce

docker:
  service.running:
    - enable: True
    - require:
      - pkg: install-docker

# At the moment we need to get docker compose directly from github. If the release version is changed here,
# the source_hash value must be updated as well.
/usr/local/bin/docker-compose:
  file.managed:
    - source: https://github.com/docker/compose/releases/download/1.17.0/docker-compose-Linux-x86_64
    - source_hash: md5=9eeb33c3a8fc2ad7c1a6458e7e51403d
    - mode: 755
