#
# Setup additional debian package repositories
#

# Required for https-based repositories
apt-transport-https:
  pkg.installed

apt-get-update:
  cmd.wait:
    - name: apt-get update

# Base debian repositories
/etc/apt/sources.list:
  file.managed:
    - source: salt://system/files/etc/apt/sources.list
    - template: jinja
    - watch_in:
       - cmd: apt-get-update

# Additional software repositories
dotdeb:
  pkgrepo.managed:
    - humanname: DotDeb repo ({{ grains.lsb_distrib_codename }})
    - name: deb http://packages.dotdeb.org {{ grains.lsb_distrib_codename }} all
    - file: /etc/apt/sources.list.d/dotdeb.list
    - key_url: http://www.dotdeb.org/dotdeb.gpg
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

docker-repo:
 pkgrepo.managed:
   - humanname: Official Docker Repository
   - name: deb https://apt.dockerproject.org/repo debian-{{ grains.lsb_distrib_codename }} main
   - file: /etc/apt/sources.list.d/docker.list
   - keyid: 58118E89F3A912897C070ADBF76221572C52609D
   - keyserver: p80.pool.sks-keyservers.net
   - refresh_db: False
   - watch_in:
      - cmd: apt-get-update

elasticsearch-repo:
  pkgrepo.managed:
    - humanname: Official Elasticsearch Repository
    - name: deb http://packages.elastic.co/elasticsearch/2.x/debian stable main
    - file: /etc/apt/sources.list.d/elasticsearch.list
    - key_url: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

beats-repo:
  pkgrepo.managed:
    - humanname: Official Beats Repository
    - name: deb https://packages.elastic.co/beats/apt stable main
    - file: /etc/apt/sources.list.d/beats.list
    - key_url: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

{{ grains.lsb_distrib_codename }}-backports-repo:
  pkgrepo.managed:
    - humanname: Debian {{ grains.lsb_distrib_codename }} Backports repository
    - name: deb http://ftp.uk.debian.org/debian {{ grains.lsb_distrib_codename }}-backports main
    - file: /etc/apt/sources.list.d/backports.list
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

nodesource-node-repo:
  pkgrepo.managed:
    - humanname: NodeSource NodeJS repository
    - name: deb https://deb.nodesource.com/node_6.x {{ grains.lsb_distrib_codename }} main
    - file: /etc/apt/sources.list.d/nodesource.list
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

yarn-repo:
  pkgrepo.managed:
    - humanname: Yarn repository
    - name: deb https://dl.yarnpkg.com/debian/ stable main
    - file: /etc/apt/sources.list.d/yarn.list
    - key_url: https://dl.yarnpkg.com/debian/pubkey.gpg
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

jenkins-repo:
  pkgrepo.managed:
    - humanname: Jenkins repository
    - name: deb http://pkg.jenkins-ci.org/debian binary/
    - file: /etc/apt/sources.list.d/jenkins.list
    - key_url: http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

postgresql-repo:
  pkgrepo.managed:
    - humanname: Postgresql repository ({{ grains.lsb_distrib_codename }})
    - name: deb http://apt.postgresql.org/pub/repos/apt/ {{ grains.lsb_distrib_codename }}-pgdg main
    - file: /etc/apt/sources.list.d/postgresql.list
    - key_url: http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

php-repo:
  pkgrepo.managed:
    - humanname: PHP7.1 repository
    - name: deb https://packages.sury.org/php/ {{ grains.lsb_distrib_codename }} main
    - file: /etc/apt/sources.list.d/php.list
    - key_url: https://packages.sury.org/php/apt.gpg
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

rabbitmq-repo:
  pkgrepo.managed:
    - humanname: RabbitMQ repository
    - name: deb http://www.rabbitmq.com/debian/ testing main
    - file: /etc/apt/sources.list.d/rabbitmq.list
    - key_url: https://www.rabbitmq.com/rabbitmq-release-signing-key.asc
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

git-repo:
  pkgrepo.managed:
    - humanname: Official Git Ubuntu Repository
    - name: deb http://ppa.launchpad.net/git-core/ppa/ubuntu lucid main
    - file: /etc/apt/sources.list.d/git.list
    - keyid: E1DF1F24
    - keyserver: keyserver.ubuntu.com
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

mysql-server-repo:
  pkgrepo.managed:
    - humanname: Official MySQL server repository
    - name: deb http://repo.mysql.com/apt/debian/ {{ grains.lsb_distrib_codename }} mysql-5.7
    - file: /etc/apt/sources.list.d/mysql-server.list
    - keyid: 5072E1F5
    - keyserver: pool.sks-keyservers.net
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update

mysql-tools-repo:
  pkgrepo.managed:
    - humanname: Official MySQL tools repository
    - name: deb http://repo.mysql.com/apt/debian/ {{ grains.lsb_distrib_codename }} mysql-tools
    - file: /etc/apt/sources.list.d/mysql-tools.list
    - keyid: 5072E1F5
    - keyserver: pool.sks-keyservers.net
    - refresh_db: False
    - watch_in:
       - cmd: apt-get-update
