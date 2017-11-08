# Reference vagrant repository for Spryker SaltStack

This repository contains Vagrantfile which is responsible for setting up
initial state of the Dev VM.

Please refer to the [Installation guide](http://spryker.github.io/getting-started/installation/guide/) to install Spryker.

## VM Settings
The VM will start with the default configuration for project `demoshop` and IP `10.10.0.33`.
If you would like to change project name, you need to edit `Vagrantfile` and change value of
variable `VM_PROJECT` (ie. to demoshop, project) and `VM_IP` - last digit. The IP address must
be unique, so each VM on your workstation must have unique IP address. The generated hostnames
will be using value of `VM_PROJECT`, so by default the hostnames will be:
```
www.de.demoshop.local
zed.de.demoshop.local
static.demoshop.local
www-test.de.demoshop.local
zed-test.de.demoshop.local
static-test.demoshop.local
```

## Version tree and lifecycle
After release CI-119 we stop using auto-increment release numbers and switch to semantic versioning. Next version becomes "1.0.0." Branch `master` is the main branch for version `1.x.x`. In future, branch `development` is the main branch for version `2.x.x`

### 1.x.x
1.x.x is current stable version, recommended for everyone unless instructed specifically to use another version, for a reason.

### 2.x.x
Improved support for multi-store
Upgraded components: (tbd)
Breaking changes: (tbd)
Possibility of self-building the release for the project (documentation)


## Customizing the VM

### PHP development modules
The PHP module `xdebug` are pre-installed on the DevVM, but not enabled by default. To enable it, use the following commands:
```
# Enable XDebug
sudo -i bash -c "phpenmod -v 7.1 -s cli -m xdebug; phpenmod -v 7.1 -s fpm -m xdebug; service php7.1-fpm restart"

# Disable XDebug
sudo -i bash -c "phpdismod -v 7.1 -s cli -m xdebug; phpdismod -v 7.1 -s fpm -m xdebug; service php7.1-fpm restart"
```
