# devvm

**DEPRECATED**

We will soon deprecate the DevVM and stop supporting it. Therefore, we highly recommend [Docker SDK](https://docs.spryker.com/docs/scos/dev/the-docker-sdk/202204.0/the-docker-sdk.html#docker-sdk-repository-structure). To install Spryker, refer to [Installing Spryker with Docker](https://docs.spryker.com//docs/scos/dev/setup/installing-spryker-with-docker/installing-spryker-with-docker.html)


Spryker DevVM (development vm)
This repository contains the Vagrantfile for setting up initial state of the DevVM. Provisioning of the machine is done using SaltStack.
For more information:

Please take a look at docs for more information:
[docs](https://docs.spryker.com/docs/scos/dev/setup/installing-spryker-with-vagrant/b2b-or-b2c-demo-shop-installation-mac-os-or-linux-with-development-virtual-machine.html#install-prerequisites)
[Internal docs](https://spryker.atlassian.net/wiki/spaces/DIO/pages/2836660432/DevVM+-+v4.1.0)



## Changelog
- Using Spryker mirror of Jenkins repository
- Update outdated Bintray repository
- PHP 8.0
- Build optimal variables_hash
- Release new endpoints
- Initial support for Cronicle
- Bug fixes and other minor improvements