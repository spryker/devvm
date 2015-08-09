# Reference vagrant repository for Spryker SaltStack

This repository contains Vagrantfile which is responsible for setting up
initial state of the Dev VM.

## Requirements
 * Unix-compatible operating system (tested on Mac OS X and Linux)
 * git
 * [Oracle VirtualBox](https://www.virtualbox.org/)
 * [Vagrant](https://www.vagrantup.com/)

## Configuration
Please view and edit at least remote repositories in `Vagrantfile`

## Usage
```
vagrant up
```

## What it does?
The `Vagrantfile` is executing following actions:
 * Cloning Saltstack, Pillar and (optionally) Spryker repositories
 * Setting up /etc/hosts entries
 * Starting the machine
 * Setting up shared folders
 * Setting port forwarding
 * Provisioning the machine using Saltstack and values from Pillar repository

## Documentation
 * Spryker [reference salstack](https://github.com/spryker/saltstack) repository
