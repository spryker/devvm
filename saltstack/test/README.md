# ServerSpec tests
Those tests check server provisioning - running services, etc. - all things
that can be checked that do not depend on any code or data

## Running it
To execute test suite: inside the VM, go to the directory with the testfiles
(ie. `/srv/salt/test`) and run complete test suite:
```
cd /srv/salt/test
sudo rake2.1 spec:server
```

## Pre-requisities
Packages required to run ServerSpec tests are installed by Saltstack. If you want
to install them manually, make sure that system has installed ruby with gems
`serverspec`, `serverspec-extended-types` and `rake`
