#
# Install docker-engine, docker-compose
#

docker.io:
  pkg.removed

docker-engine:
  pkg.installed

docker:
  service.running:
    - enable: True

# At the moment we need to get docker compose directly from github. If the release version is changed here,
# the source_hash value must be updated as well.
/usr/local/bin/docker-compose:
  file.managed:
    - source: https://github.com/docker/compose/releases/download/1.8.0/docker-compose-Linux-x86_64
    - source_hash: md5=6a598739bda87a591efbcdc9ab734da1
    - mode: 755
