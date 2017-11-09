#
# Topfile - used by salt ... state.highstate
#

# Production-like setup - we apply specific states to machines
qa:
  # apply to all roles
  '*':
    - system
    - hosting
    - user
    - postfix
    - newrelic
    - ruby

  # php and application code
  'roles:app':
    - match: grain
    - php
    - spryker
    - nodejs

  # nginx and web components
  'roles:web':
    - match: grain
    - nginx
    - newrelic.php
    - nodejs

  # jenkins to run cronjob and indexers
  'roles:cronjobs':
    - match: grain
    - spryker
    - java
    - jenkins
    - newrelic.php

  # elasticsearch (for spryker data)
  'roles:elasticsearch':
    - match: grain
    - java
    - elasticsearch

  # Rabbit MQ
  'roles:queue':
    - match: grain
    - rabbitmq

  # Redis
  'roles:redis':
    - match: grain
    - redis

  # Database
  'roles:postgresq':
    - match: grain
    - postgresql
  'roles:mysql':
    - match: grain
    - mysql-server

base:
  '*':
    - system
    - user

dev:
  # apply all states on a single machine, don't divide by roles
  '*':
    - system
    - hosting
    - user
    - postfix
    - docker
    - mysql-server
    - postgresql
    - rabbitmq
    - ruby
    - nodejs
    - php
    - java
    - development
    - mailcatcher
    - elk
    - nginx
    - pound
    - jenkins
    - redis
    - samba
    - elasticsearch
    - serverspec
    - spryker
