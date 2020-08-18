# Spryker OS - Reference repository for DevVM

This repository contains Vagrantfile which is responsible for setting up
initial state of the Dev VM. Provisioning of the machine is done using SaltStack.

Please refer to the [Installation guide - B2C](https://documentation.spryker.com/installation/installation-guide-b2c.htm) or [Installation guide - B2B](https://documentation.spryker.com/installation/installation-guide-b2b.htm) to install Spryker.

This repository contains:
 - [saltstack](saltstack) - SaltStack implementation for provisioning reference infrastructure for development
 - [pillar](pillar) - Pillar configuration values used by SaltStack
 - Vagrantfile(s) used by Vagrant for managing local VirtualBox VMs

## Requirements
 - VirtualBox >= 5.2.x
 - Vagrant >= 2.2.3
 - `vagrant-hostmanager` plugin

## VM Settings
The VM will start with the default configuration for project `demoshop` and IP `10.10.0.33`.
If you would like to change project name, you need to edit `Vagrantfile` and change value of
variable `VM_PROJECT` (ie. to demoshop, project) and `VM_IP` - last digit only. The IP address must
be unique, so each VM on your workstation must have unique IP address.
You should also adjust `VM_DOMAIN` to the value that corresponds to your config_default-development
hostnames. If you do not specify value of `VM_DOMAIN`, it will take the value
from `VM_PROJECT`.

As an example, for default `VM_PROJECT=demoshop` - following hostnames will
be generated:

```
www.de.demoshop.local
zed.de.demoshop.local
static.demoshop.local
www-test.de.demoshop.local
zed-test.de.demoshop.local
static-test.demoshop.local
```

## Note on PHP opcache
In order to use opcache for CLI calls as well, the VM ships with PHP opcache file cache enabled. Cache contents are stored in `/var/tmp/opcache` directory. After enabling/disabling PHP modules (and as a possible fix if you are getting unexpected PHP error, like Segmentation fault), you must clean the cache directory with:
```
sudo rm -rf /var/tmp/opcache/*; sudo systemctl restart php7.4-fpm
```

## Customizing the VM

### PHP development modules
The PHP module `xdebug` are pre-installed on the DevVM, but not enabled by default.
Using `xdebug` and `opcache` at the same time might be dangerous and is not recommended.
To enable xdebug, use the following commands:
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

Running with xdebug enabled and opcache disabled will cause the application to be slower, so consider
enabling it only when you need. To disable xdebug and re-enable opcache, use the following commands:
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
After release `ci-119` we decided to stop using auto-incremented release numbers and switch to semantic versioning. Next version becomes `1.0.0`.
We follow git-flow - branch `master` is used to release tested features, where branch `develop` is used for release candidates (tags like `v2.0.0-RC1`)
and is merged into master whenever we officialy release new version, after internal QA process.


### 1.x.x
1.x.x is old stable version, with PHP 7.1 and Elasticsearch 2.x

### 2.x.x
2.x.x is non-backward-compatible version, which includes PHP 7.2 and Elasticsearch 5.x


