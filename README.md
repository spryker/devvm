# Akona fork of the spryker DevVM

This repository contains the Vagrantfile for setting up initial state of the DevVM. Provisioning of the machine is done using SaltStack.

Please refer to our [Confluence Installation guide](https://winterhalter-fenner.atlassian.net/wiki/spaces/WF/pages/98533438/Getting+started).

## Requirements
 - VirtualBox >= 5.2.x
 - Vagrant >= 2.2.0
 - Vagrant >= 2.2.3
 - `vagrant-hostmanager` plugin

## VM Settings
Project `akona` and IP `10.10.0.159`.
The following hostnames will be generated:

```
akona-vagrant
www.wf.akona.local
zed.wf.akona.local
glue.wf.akona.local
www.el.akona.local
zed.el.akona.local
glue.el.akona.local
www.ep.akona.local
zed.ep.akona.local
glue.ep.akona.local
www.dy.akona.local
zed.dy.akona.local
glue.dy.akona.local
www.fa.akona.local
zed.fa.akona.local
glue.fa.akona.local
static.akona.local
www-test.wf.akona.local
zed-test.wf.akona.local
glue-test.wf.akona.local
www-test.el.akona.local
zed-test.el.akona.local
glue-test.el.akona.local
www-test.ep.akona.local
zed-test.ep.akona.local
glue-test.ep.akona.local
www-test.dy.akona.local
zed-test.dy.akona.local
glue-test.dy.akona.local
www-test.fa.akona.local
zed-test.fa.akona.local
glue-test.fa.akona.local
static-test.akona.local
```

## Note on PHP OPcache
To use OPcache for CLI calls, the VM ships with PHP opcache file cache enabled. Cache contents are stored in `/var/tmp/opcache`. After enabling or disabling PHP modules, for example to fix an unexpected PHP error like Segmentation fault, make sure to clear cache by running the command:
```
sudo rm -rf /var/tmp/opcache/*; sudo systemctl restart php7.4-fpm
```

## Customizing the VM

### PHP development modules
The PHP module `xdebug` is pre-installed on the DevVM, but not enabled by default.
We do not recommend using `xdebug` and `opcache` simultaneously as it is dangerous.
To enable Xdebug, run the commands:
```
# Enable XDebug, disable OpCache, clear disk cache, restart FPM
sudo -i bash -c " \
  phpenmod -v 7.4 -s cli -m xdebug; \
  phpenmod -v 7.4 -s fpm -m xdebug; \
  phpdismod -v 7.4 -s cli -m opcache; \
  phpdismod -v 7.4 -s fpm -m opcache; \
  rm -rf /var/tmp/opcache/*; \
  systemctl restart php7.4-fpm \
  "
```

Running with xdebug enabled and opcache disabled cause the application to be slower, so consider
keeping it disabled when not needed. To disable Xdebug and re-enable OPcache, run the commands:
```
# Disable XDebug, enable OpCache, clear disk cache, restart FPM
sudo -i bash -c " \
  phpdismod -v 7.4 -s cli -m xdebug; \
  phpdismod -v 7.4 -s fpm -m xdebug; \
  phpenmod -v 7.4 -s cli -m opcache; \
  phpenmod -v 7.4 -s fpm -m opcache; \
  rm -rf /var/tmp/opcache/*; \
  systemctl restart php7.4-fpm \
  "
```


## Version tree and lifecycle
After release `ci-119`, we decided to stop using auto-incremented release numbers and switch to semantic versioning. Next version becomes `1.0.0`.
We follow git-flow:
* Branch `master` is used to release tested features.
* Branch `develop` is used for release candidates (tags like `v2.0.0-RC1`) and is merged into master whenever we officialy release a new version, after internal QA process.


### 1.x.x
PHP 7.1 and Elasticsearch 2.x [EOL]

### 2.x.x
Includes PHP 7.2 and Elasticsearch 5.x

### 3.x.x
Upgraded Elasticsearch to 7.8.1, Kibana to 7.8.1, since 3.1.0 also PHP 7.4
