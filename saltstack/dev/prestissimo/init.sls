# Install hirak/prestissimo to make composer faster

install-prestissimo:
  cmd.run:
    - name: /usr/local/bin/composer global require hirak/prestissimo
    - unless: test -d /home/vagrant/.composer/vendor/hirak/prestissimo
    - runas: vagrant
