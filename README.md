# Akona fork of the spryker DevVM

This repository contains Vagrantfile which is responsible for setting up
initial state of the Dev VM. Provisioning of the machine is done using SaltStack.

Please refer to our [Confluence Installation guide](https://winterhalter-fenner.atlassian.net/wiki/spaces/WF/pages/98533438/Getting+started).

## Requirements
 - VirtualBox >= 5.2.x
 - Vagrant >= 2.2.0
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

## Note on PHP opcache
In order to use opcache for CLI calls as well, the VM ships with PHP opcache file cache
enabled. Cache contents are stored in `/var/tmp/opcache` directory.


After enabling/disabling PHP modules (and as a possible fix if you are
getting unexpected PHP error, like Segmentation fault), you must clean
the cache directory with:
```
sudo rm -rf /var/tmp/opcache/*; sudo systemctl restart php7.2-fpm
```
