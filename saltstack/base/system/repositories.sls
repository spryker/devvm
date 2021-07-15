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

docker-repo:
 pkgrepo.managed:
   - humanname: Official Docker Repository
   - name: deb [arch=amd64] https://download.docker.com/linux/debian {{ grains.lsb_distrib_codename }} stable
   - file: /etc/apt/sources.list.d/docker.list
   - key_url: https://download.docker.com/linux/debian/gpg
   - refresh: False
   - watch_in:
      - cmd: apt-get-update

java-repo:
  pkgrepo.managed:
    - humanname: Java 8 Repository
    - name: deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb buster main
    - file: /etc/apt/sources.list.d/java8.list
    - key_url: https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public
    - refresh: False
    - watch_in:
       - cmd: apt-get-update


elasticsearch-repo:
  pkgrepo.managed:
    - humanname: Official Elasticsearch Repository
    - name: deb https://artifacts.elastic.co/packages/7.x/apt stable main
    - file: /etc/apt/sources.list.d/elasticsearch7.list
    - key_url: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

beats-repo:
  pkgrepo.managed:
    - humanname: Official Beats Repository
    - name: deb https://packages.elastic.co/beats/apt stable main
    - file: /etc/apt/sources.list.d/beats.list
    - key_url: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

{{ grains.lsb_distrib_codename }}-backports-repo:
  pkgrepo.managed:
    - humanname: Debian {{ grains.lsb_distrib_codename }} Backports repository
    - name: deb http://ftp.uk.debian.org/debian {{ grains.lsb_distrib_codename }}-backports main
    - file: /etc/apt/sources.list.d/backports.list
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

nodesource-node-repo:
  pkgrepo.managed:
    - humanname: NodeSource NodeJS repository
    - name: deb https://deb.nodesource.com/node_12.x {{ grains.lsb_distrib_codename }} main
    - file: /etc/apt/sources.list.d/nodesource.list
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

yarn-repo:
  pkgrepo.managed:
    - humanname: Yarn repository
    - name: deb https://dl.yarnpkg.com/debian/ stable main
    - file: /etc/apt/sources.list.d/yarn.list
    - key_url: https://dl.yarnpkg.com/debian/pubkey.gpg
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

jenkins-repo:
  pkgrepo.managed:
    - humanname: Jenkins repository
    - name: deb http://pkg.jenkins.io/debian binary/
    - file: /etc/apt/sources.list.d/jenkins.list
    - key_url: https://pkg.jenkins.io/debian/jenkins.io.key
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

postgresql-repo:
  pkgrepo.managed:
    - humanname: Postgresql repository ({{ grains.lsb_distrib_codename }})
    - name: deb http://apt.postgresql.org/pub/repos/apt/ {{ grains.lsb_distrib_codename }}-pgdg main
    - file: /etc/apt/sources.list.d/postgresql.list
    - key_url: http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

php-repo:
  pkgrepo.managed:
    - humanname: PHP repository
    - name: deb https://packages.sury.org/php/ {{ grains.lsb_distrib_codename }} main
    - file: /etc/apt/sources.list.d/php.list
    - key_url: https://packages.sury.org/php/apt.gpg
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

rabbitmq-repo:
  pkgrepo.managed:
    - humanname: RabbitMQ repository
    - name: deb http://ppa.launchpad.net/rabbitmq/rabbitmq-erlang/ubuntu bionic main
    - file: /etc/apt/sources.list.d/rabbitmq1.list
    - keyid: F77F1EDA57EBB1CC
    - keyserver: keyserver.ubuntu.com
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

rabbitmqerlang-repo:
  pkgrepo.managed:
    - humanname: RabbitMQ erlang latest repository
    - name: deb https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/deb/ubuntu bionic main
    - file: /etc/apt/sources.list.d/rabbitmqerlang.list
    - keyserver: keys.openpgp.org
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

rabbitmqserver-repo:
  pkgrepo.managed:
    - humanname: RabbitMQ latest repository
    - name: deb https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/deb/ubuntu bionic main
    - file: /etc/apt/sources.list.d/rabbitmqserver.list
    - keyserver: keys.openpgp.org
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

git-repo:
  pkgrepo.managed:
    - humanname: Official Git Ubuntu Repository
    - name: deb http://ppa.launchpad.net/git-core/ppa/ubuntu artful main
    - file: /etc/apt/sources.list.d/git.list
    - keyid: E1DF1F24
    - keyserver: keyserver.ubuntu.com
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

mysql-server-repo:
  pkgrepo.managed:
    - humanname: Official MariaDB server repository
    - name: deb [arch=amd64,i386,ppc64el] https://mirror.mva-n.net/mariadb/repo/10.4/debian {{ grains.lsb_distrib_codename }} main
    - file: /etc/apt/sources.list.d/mysql-server.list
    - key_url: https://mariadb.org/mariadb_release_signing_key.asc
    - refresh: False
    - watch_in:
       - cmd: apt-get-update

