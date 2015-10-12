# Reference vagrant repository for Spryker SaltStack

This repository contains Vagrantfile which is responsible for setting up
initial state of the Dev VM.

## Requirements
 * Unix-compatible operating system (tested on Mac OS X and Linux)
 * git
 * [Oracle VirtualBox (Version 4.3.30)](https://www.virtualbox.org/wiki/Download_Old_Builds_4_3)
 * [Vagrant (Version 1.7.2)](https://www.vagrantup.com/download-archive/v1.7.2.html)

## Configuration
Please view and edit at least remote repositories in `Vagrantfile`

## Usage
```
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
