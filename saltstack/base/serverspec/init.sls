#
# Install serverspec and its dependencies
#

rake:
  gem.installed

#serverspec:
#  gem.installed

serverspec-extended-types:
  gem.installed:
    - pkgs:
      - multipart-post:
        - version: 2.1.1
      - ruby2_keywords:
        - version: 0.0.2
      - faraday:
        - version: 1.1.0
      - rspec-support:
        - version: 3.9.4
      - rspec-core:
        - version: 3.9.3
      - diff-lcs:
        - version: 1.4.4
      - rspec-expectations:
        - version: 3.9.4
      - rspec-mocks:
        - version: 3.9.1
      - rspec:
        - version: 3.9.0
      - net-ssh:
        - version: 6.1.0
      - net-scp:
        - version: 3.0.0
      - net-telnet:
        - version: 0.1.1
      - sfl:
        - version: 2.3
      - specinfra:
        - version: 2.82.22
      - rspec-its:
        - version: 1.3.0
      - multi_json:
        - version: 1.15.0
      - serverspec:
        - version: 2.41.5
      - serverspec-extended-types:
        - version: 0.1.1
