#
# Define service reload commands here, so that the state spryker does not depend
# on the other states.
#
# The commands here are defined as "cmd.wait", so they only get called if they are
# included in watch_in element and change is triggered.


reload-php-fpm:
  cmd.wait:
    - name: service php{{ salt['pillar.get']('php:major_version') }}-fpm restart

reload-nginx:
  cmd.wait:
    - name: service nginx restart
