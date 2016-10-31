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


## Updates to VM

### RabbitMQ
RabbitMQ service has been disabled by default - the software is installed but service is not started.
It can be started manually by executing inside VM:
```
sudo -i service rabbitmq-server start
```

After starting RabbitMQ for the first time, you have to create users and vhosts to be able to access queue from application.
This only needs to be executed once:
```
sudo -i salt-call state.sls rabbitmq.credentials
```

### PHP development modules
The PHP module `xdebug` are pre-installed on the DevVM, but not enabled by default. To enable it, use the following commands:
```
# Enable XDebug
sudo -i bash -c "phpenmod -v 7.0 -s cli -m xdebug; phpenmod -v 7.0 -s fpm -m xdebug; service php7.0-fpm restart"

# Disable XDebug
sudo -i bash -c "phpdismod -v 7.0 -s cli -m xdebug; phpdismod -v 7.0 -s fpm -m xdebug; service php7.0-fpm restart"
```
