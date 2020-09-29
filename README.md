# Spryker OS - Reference repository for DevVM

This repository contains the Vagrantfile for setting up initial state of the DevVM. Provisioning of the machine is done using SaltStack.

To install Spryker, refer to [Installation guide - B2C](https://documentation.spryker.com/docs/en/b2c-demo-shop-installation-mac-os-or-linux-with-devvm) or [Installation guide - B2B](https://documentation.spryker.com/docs/en/installation-guide-b2b).

This repository contains:
 - [saltstack](saltstack) - SaltStack implementation for provisioning reference infrastructure for development
 - [pillar](pillar) - Pillar configuration values used by SaltStack
 - Vagrantfile(s) used by Vagrant for managing local VirtualBox VMs

## Requirements
 - VirtualBox >= 5.2.x
 - Vagrant >= 2.2.3
 - `vagrant-hostmanager` plugin

## VM Settings
The VM starts with the default configuration for project `demoshop` and IP `10.10.0.33`.
To change project name, edit `Vagrantfile` and change the value of
the `VM_PROJECT` (ie. to demoshop, project) and `VM_IP`(digits only) variables. The IP address must
be unique, so each VM on your workstation has a unique IP address.

Adjust the `VM_DOMAIN` variable value according to your config_default-development hostnames. 
The default value is taken from the `VM_PROJECT` variable. For example, the following hostnames 
are generated for the default value `VM_PROJECT=demoshop`:

```
www.de.demoshop.local
zed.de.demoshop.local
static.demoshop.local
www-test.de.demoshop.local
zed-test.de.demoshop.local
static-test.demoshop.local
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
