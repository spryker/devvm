# Reference saltstack repository for Spryker
This repository contains salt states (implementation) for Spryker SaltStack.
It is a reference repository, which should be cloned and used as a base for
specific projects. Please see steps below for information how to create a new
project, including security credentials.

## Documentation
For working with SaltStack you should familiarize yourself with at least basic
concepts of this technology. The best way to start is to read the official
[SaltStack tutorials](http://docs.saltstack.com/en/latest/topics/tutorials/index.html).


## Creating new Spryker project

1. Clone `spryker` code repository

1. Clone `saltstack` and `pillar` reference repositories. You should use names like `saltstack-PROJECT` and `pillar-PROJECT-dev` - where PROJECT is the project name (e.g. `toys`).
Keep those repositories private. In future you will have more than one pillar repository - i.e. seperate for dev (development VMs), for qa (testing systems) and for production.
You can always merge changes from the reference repositories, but from the beginning you should not use reference repositories directly.

1. Edit the `Vagrantfile` in your Spryker repository:
    1. Change `VM_IP` parameter - use any other value other than the default one. You should pick up an address somewhere inside 10.0.0.0/8 network, which does not collide with your
    office / server address spaces. For example, you can use `10.10.1.34`.
    1. Adjust the values of `SALT_REPOSITORY` and `PILLAR_REPOSITORY` variables, so that they point to repositories you just created.

1. Generate new SSH keys for checking out code:
    1. Create a temporary directory on your hard drive. In this directory create set of SSH keys, without password:

        ```
        $ mkdir temp; cd temp
        $ ssh-keygen -N '' -f deployment -C 'spryker-deployment-PROJECT'
        ```

    1. Copy the private key from file `deployment` to repository `saltstack`, file `base/spryker/files/etc/deploy/deploy.key`
    1. Upload the public key from file `deployment.pub` to your `spryker` git repository as read-only deployment key. In GitHub you can do that by selecting your spryker repository,
  then clicking on `Settings` and then on `Deploy keys`.

1. Generate new SSH keys for inter-server deployment connections. Note that `pillar-dev`, `pillar-qa` and `pillar-prod` repositories
    should all have different keys - you want to give access to production system only to limited amount of people. Keep those keys very
    secret, as they allow critical access to your severs.
    1. To generate dev key, use the following commands:

        ```
        $ cd temp
        $ ssh-keygen -N '' -f dev -C 'spryker-dev'
        ```

1. Copy the contents of private key from file `dev` and paste them to your pillar repository, into file `dev/app/init.sls`,
    as key `server_env:ssh:id_rsa`. Watch out for correct indentations in the yaml file! E.g.:
    ```
    server_env:
      ssh:
        id_rsa: |
          -----BEGIN RSA PRIVATE KEY-----
          XXxxXXxxXXxxXXxxXXxxXXxxXXxxXXxxXXxx
          -----END RSA PRIVATE KEY-----
    ```

1. Remove the temporary directory with key files from your local hard drive:
    ```
    $ rm -ri temp
    remove temp/deployment? y
    remove temp/deployment.pub? y
    remove temp/dev? y
    remove temp/dev.pub? y
    remove temp? y
    ```

## Deployment

### Using AgentForwarding for deployment SSH keys
For previous Spryker/Yves&Zed project, we have been using "deployment ssh key", which allowed checking out code from github/codebase during deployment.
As this is potential security issue, deployment key is not mandatory anymore. If the /etc/deploy/deploy.key file is present, the key will be used.
If the file is not present, deployment will use SSH Agent Forwarding to use directly developer's key for getting the code from repositories.
To enable SSH Agent Forwarding, add the following line to .ssh/config configuration file:
`ForwardAgent yes`
This option can also be enabled on windows PuTTY ssh client.
If in doubt, there is always the possibility to fallback to deployment key in file /etc/deploy/deploy.key

Background information: https://developer.github.com/guides/using-ssh-agent-forwarding/

### IP Addresses and DNS records
Spryker development VM uses some domains:
 - www.de.demoshop.local
 - zed.de.demoshop.local
 - static.demoshop.local
 - www-test.de.demoshop.local
 - zed-test.de.demoshop.local
 - static-test.demoshop.local
Those DNS records point to private IP address assigned to the VM - `10.10.0.33`.
The VM also includes valid wildcard SSL certificates for both domains.

The self-signed SSL certificate for `*.local`, `*.*.local`, `*.*.*.local` and `*.*.*.*.local` is already in the VM and Pound configuration.

### Services in the VM:
MailCatcher - http://www.de.demoshop.local:1080/


### Notes for production deployments
This SaltStack repository includes all the components required to run multi-environment,
multi-store setup of Spryker on development VM. It also can be used to setup QA and
production environments. Some of the components in production need special care to provide
high-available, auto-failover service. It can be achieved by either software implementation
(for example, redis replication / redis cluster) or managed services (ObjectRocket, ElastiCache, etc.)
Those services are:
 - Redis
 - MySQL / PostgreSQL database
 - Elasticsearch cluster (consisting of at least three nodes)
 - CDN for static content delivery -OR- NAS attached to all the machines for sharing static files and high-performance, caching webserver (like Squid, Varnish proxy to NginX) -OR- Cloud-based object storage
 with CDN feature (like S3+CloudFront, Rackspace Cloudfiles CDN)


### Port numbering
For all services, there is a constant port numbering scheme. Each has a meaning.
The values from this document should be reflected in state base/settings/port_numbering.

#### LEDDC

Where:

#### L - Listener
1 for applications with one / default listener only, 1/2/... for applications with more than one
possible listenere (for example, Elasticsearch has both HTTP and Transport ports).

| ID     | Listener                                  |
| ------ | ----------------------------------------- |
| 1      | default (*) / HTTP (NginX, Elasticsearch) |
| 2      | Transport (Elasticsearch)                 |

#### E - Environment
The possible values for Environment should be updated in file:
salt/base/settings/port_numbering.sls

| ID     | Environment                               |
| ------ | ----------------------------------------- |
| 5      | Production                                |
| 3      | Staging                                   |
| 1      | Testing                                   |
| 0      | Development                               |


#### DD - AppDomain for multiple country instances
Default value: 00 (appropiate for ALL single-languages components)
The possible values for AppDomain should be updated in file:
salt/base/settings/port_numbering.sls

| AppDomain | Country name (English) | Store | Default language |
| ------ | ------------------------- | ----- | ---------------- |
| 00     | Germany (or default)      | DE    | de_DE            |
| 01     | Poland                    | PL    | pl_PL            |
| 02     | France                    | FR    | fr_FR            |
| 03     | Austria                   | AT    | de_AT            |
| 04     | Netherlands               | NL    | nl_NL            |
| 05     | Switzerland               | CH    | de_CH            |
| 06     | Brazil                    | BR    | pt_BR            |
| 07     | United Kingdom            | UK    | en_UK            |
| 08     | Italy                     | IT    | it_IT            |
| 09     | Belgium                   | BE    | nl_BE            |
| 10     | USA                       | US    | en_US            |
| 11     | Mexico                    | MX    | es_MX            |
| 12     | Argentina                 | AR    | es_AR            |
| 13     | Chile                     | CL    | es_CL            |
| 14     | Columbia                  | CO    | es_CO            |
| 15     | Canada                    | CA    |                  |
| 16     | Spain                     | ES    | es_ES            |
| 17     | Portugal                  | PT    | pt_PT            |
| 18     | Ireland                   | IE    |                  |
| 19     | Denmark                   | DK    |                  |
| 20     | Sweden                    | SE    |                  |
| 21     | Norway                    | NO    |                  |
| 22     | Finland                   | FI    |                  |
| 23     | Czech Republic            | CZ    |                  |
| 24     | Slovakia                  | SK    |                  |
| 25     | Hungary                   | HU    |                  |
| 26     | Greece                    | GR    |                  |
| 27     | Slovenia                  | SI    |                  |
| 28     | Romania                   | RO    |                  |
| 29     | Croatia                   | HR    |                  |
| 30     | Turkey                    | TR    |                  |
| ...    |                           |       |                  |
| 98     | (reserved) International  | COM   | en_UK            |
| 99     | (reserved) Europe         | EU    | en_UK            |


#### C - Component, from following list:

| ID     | Component                                 |
| ------ | ----------------------------------------- |
| 0      | Yves                                      |
| 1      | Zed                                       |
| 2      | Static web content                        |
| 3      |                                           |
| 4      |                                           |
| 5      | Search (elasticsearch)                    |
| 6      | Queue (rabbitMQ)                          |
| 7      | Jenkins                                   |
| 8      | Cache (memcached)                         |
| 9      | K/V Datastore (redis)                     |

Examples:
 - 15000 - Production YVES, Germany, HTTP
 - 15101 - Production ZED, USA, HTTP
 - 13007 - Staging Jenkins, HTTP (no store specified - jenkins runs per-environment)
 - 10005 - Development Elasticsearch, HTTP (no store specified)
