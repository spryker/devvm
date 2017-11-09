#
# Update mysql package
#
# Note: this state is included only if pillar setting autoupdate:mysql is true

update-mysql:
  pkg.latest:
    - name: mysql-community-server
