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

Also make sure you got the `vbguest` and `hostmanager` plugins installed:
```
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-hostmanager
```

## Usage
```
vagrant up
```

## Troubleshooting (Mac OS X)

#### Error on box image download
If you get an error on downloading `debian81.box` image file, then go to
https://github.com/korekontrol/packer-debian8/releases/download/1.1/debian81.box
and download it manually, than run command:

```
vagrant box add /path/to/downloaded/image/debian81.box --name debian81
vagrant up
```

#### NFS is reporting that your exports file is invalid

> This may happend if you have previous VMs created and not removed properly or even if you share the computer with someone else who has VMs installed.

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

## Quick start
Go to [GitHub release page](https://github.com/spryker/devvm/releases/latest), copy the link of file "spryker-devvm.box".
Use this command to create VM, replacing URL with the copied link from above:
```
vagrant init devvm https://github.com/spryker/devvm/releases/download/ci-23/spryker-devvm.box
vagrant up
```
