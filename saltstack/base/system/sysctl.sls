#
# Linux kernel tuning
#

# Unix socket connection backlog size
net.core.somaxconn:
  sysctl.present:
    - value: 4096

# Minimize disk swapping
vm.swappiness:
  sysctl.present:
    - value: 5
