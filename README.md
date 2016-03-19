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
Make sure that plugins described above in "Before starting" are installed.
Go to [GitHub release page](https://github.com/spryker/devvm/releases/latest), copy the link of file "spryker-devvm.box".
Before you use this command to create VM you need to:
* replace example number "999" in box name, e.g. `devvm35` 
* and url with the copied link from above:
```
vagrant init devvm999 https://github.com/spryker/devvm/releases/download/ci-999/spryker-devvm.box
```

Edit the Vagrantfile and add hostmanager configuration at the end. File should end like:
```
(...)
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
end
```

Start the VM:
```
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

## Troubleshooting

#### NFS exports are not supported on encprypted filesystems (Linux)
`nfs-kernel-server` can not be used to share folders on encrypted filesystem in Linux. There is no workaround known yet. Spryker code must be placed on non-encrypted filesystem in order to allow sharing folders with Vagrant using NFS.

#### Error on box image download
If you get an error on downloading `debian83.box` image file, then go to
https://github.com/korekontrol/packer-debian8/releases/download/ci-9/debian83.box
and download it manually, than run command:

```
vagrant box add /path/to/downloaded/image/debian83.box --name debian83
vagrant up
```

#### NFS exoprts issue
The error is:
```
NFS is reporting that your exports file is invalid. Vagrant does
this check before making any changes to the file. Please correct
the issues below and execute "vagrant reload":

exports:3: path contains non-directory or non-existent components: /Users/hussamhebbo/Development/devvm/pillar
exports:3: no usable directories in export entry
exports:3: using fallback (marked offline): /
exports:4: path contains non-directory or non-existent components: /Users/hussamhebbo/Development/devvm/saltstack
exports:4: no usable directories in export entry
exports:4: using fallback (marked offline): /
```

The fix is:
```
sudo rm /etc/exports
sudo touch /etc/exports
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
