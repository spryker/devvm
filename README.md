# Reference vagrant repository for Spryker SaltStack

This repository contains Vagrantfile which is responsible for setting up
initial state of the Dev VM.

Please refer to the [Installation guide](http://spryker.github.io/getting-started/installation/guide/) to install Spryker.

# Updates to VM

## RabbitMQ
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

## PHP development modules
The PHP modules `xdebug` and `xhprof` are pre-installed on the DevVM, but not enabled by default. To enable one of them, use the following commands:
```
# Enable XDebug
sudo -i bash -c "php5enmod -s cli -m xdebug; php5enmod -s fpm -m xdebug; service php5-fpm restart"

# Enable xhprof
sudo -i bash -c "php5enmod -s cli -m xhprof; php5enmod -s fpm -m xhprof; service php5-fpm restart"

# Disable XDebug
sudo -i bash -c "php5dismod -s cli -m xdebug; php5dismod -s fpm -m xdebug; service php5-fpm restart"

# Disable xhprof
sudo -i bash -c "php5dismod -s cli -m xhprof; php5dismod -s fpm -m xhprof; service php5-fpm restart"
```
