#
# Install serverspec and its dependencies
#

rake:
  gem.installed

serverspec:
  gem.installed

serverspec-extended-types:
  gem.installed
    - version: 0.1.1
