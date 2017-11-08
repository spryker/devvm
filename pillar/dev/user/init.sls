# This pillar represents a list of operating system users. Multiple users can be specified.
#
# On dev environment we define only vagrant user and change the shell of this user to zsh
# Please note that removing an user from pillar will not remove user from operating system.

user:
  # Name of user
  # Mandatory, no default value
  vagrant:

    # Full name of the user
    # Mandatory, no default value
    fullname: Vagrant User

    # Allow the user to run "sudo" command?
    # Optional, default: False
    admin: True

    # Shell for the user
    # Optional, default: /bin/bash
    shell: /bin/zsh

    # Public SSH key for the user
    # Optional, no default value
    #ssh_key: |
    #  ssh-rsa xxxxxxxxxxxx user@host

