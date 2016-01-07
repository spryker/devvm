# Reference vagrant repository for Spryker SaltStack

This repository contains Vagrantfile which is responsible for setting up
initial state of the Dev VM.

## Requirements
 * Unix-compatible operating system (tested on Mac OS X and Linux)
 * git
 * [Oracle VirtualBox (Version 4.3.30)](https://www.virtualbox.org/wiki/Download_Old_Builds_4_3)
 * [Vagrant (Version 1.7.2)](https://www.vagrantup.com/download-archive/v1.7.2.html)

## Configuration
Please view and edit at least remote repositories in `Vagrantfile`.

Also make sure you got the `vbguest` plugin installed:
```
vagrant plugin install vagrant-vbguest
```

## Usage
```
vagrant up
```

## Troubleshooting (Mac OS X)

If you get an error on downloading `debian81.box` image file, then go to
https://github.com/korekontrol/packer-debian8/releases/download/1.1/debian81.box
and download it manually, than run command:

```
vagrant box add /path/to/downloaded/image/debian81.box --name debian81
vagrant up
```


## What it does?
The `Vagrantfile` is executing following actions:
 * Cloning Saltstack, Pillar and Spryker repositories
 * Setting up /etc/hosts entries
 * Starting the machine
 * Setting up shared folders
 * Setting port forwarding
 * Provisioning the machine using Saltstack and values from Pillar repository

## Documentation
 * Spryker [reference salstack](https://github.com/spryker/saltstack) repository
 
## Configure the VM to your needs

If you want to commit from within the VM just set the right git preferences:

```
git config --global user.email <your.email@domain.tld>
git config --global user.name <Your Name>
```

## Update the VM configuration

When the VM configuration should be updated via saltstack there is no need to destroy your VM and create a new one, just execute the following commands:

In the project directory (outside of VM):
```
cd saltstack/
git pull
cd ../pillar
git pull
cd ..
vagrant ssh
```

Inside the VM:
```
sudo -i
salt-call --local state.highstate
```

Afterwards your VM has the newest configuration and dependencies

