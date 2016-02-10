# Reference vagrant repository for Spryker SaltStack

This repository contains Vagrantfile which is responsible for setting up
initial state of the Dev VM.

## Requirements
 * Unix-compatible operating system (tested on Mac OS X and Linux) or Microsoft Windows (tested on Windows 10)
 * git
 * [Oracle VirtualBox (Version 5.0.14+)](https://www.virtualbox.org/wiki/Downloads)
 * [Vagrant (Version 1.7.4+)](https://www.vagrantup.com/downloads.html)

## Before starting
Please view and edit at least remote repositories in `Vagrantfile`.

Also make sure you got the `vbguest` and `hostmanager` plugins installed:
```
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-hostmanager
```

## Quick start
Go to [GitHub release page](https://github.com/spryker/devvm/releases/latest), copy the link of file "spryker-devvm.box".
Use this command to create VM, replacing example number "999" in box name and url with the copied link from above:
```
vagrant init devvm999 https://github.com/spryker/devvm/releases/download/ci-999/spryker-devvm.box
vagrant up
```

## Usage
```
vagrant up
```

### What it does?
The `Vagrantfile` is executing following actions:
 * Clone Saltstack, Pillar and Spryker repositories
 * Set up /etc/hosts entries
 * Start the machine
 * Setup shared folders (except Windows platform)
 * Setup port forwarding
 * Provision the machine using Saltstack and values from Pillar repository

It's also possible to skip time-consuming provisioning operation and use ready box file, as described
in "Quick start"

## Documentation
 * Spryker [reference salstack](https://github.com/spryker/saltstack) repository

## Configuration of git VM
If you want to commit from within the VM you must set the right git preferences:

```
git config --global user.email <your.email@domain.tld>
git config --global user.name <Your Name>
```

## Update of VM
If the VM configuration should be updated via SaltStack there is no need to destroy your VM and create a new one.
Updates can be applied by executing the following commands:

In the project directory on your host operating system (outside of VM):
```
cd saltstack; git pull; cd ..
cd pillar; git pull; cd ..
vagrant ssh
```

Inside the VM guest system:
```
sudo -i salt-call state.highstate
```

Afterwards your VM has the newest configuration and dependencies

## Troubleshooting (Mac OS X)

#### Error on box image download
If you get an error on downloading `debian83.box` image file, then go to
https://github.com/korekontrol/packer-debian8/releases/download/ci-9/debian83.box
and download it manually, than run command:

```
vagrant box add /path/to/downloaded/image/debian83.box --name debian83
vagrant up
```

#### NFS is reporting that your exports file is invalid

> This may happen if you have previous VMs created and not properly destroyed (or even if you share the computer with someone else who had other VMs).

```
sudo sed -i .bak '/VAGRANT-BEGIN/,/VAGRANT-END/d' /etc/exports
```

Reinitialize VM

```
vagrant halt
vagrant up --provision

# or

vagrant destroy
vagrant up
```
