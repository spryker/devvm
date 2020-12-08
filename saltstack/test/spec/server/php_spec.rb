require 'spec_helper'

# Note: this is a rather smelly test, which changes state of the
# system and restores it later:
# It checks the default behaviour (xdebug disabled),
# Then it enables xdebug and tests it
# Then it disables xdebug and tests it
#
# As this image is later packaged and distributed, it's very
# important that the state is unchanged after running tests.
# Therefore we depend on test execution order.


describe 'php' do
  let(:path) { '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
  PHP_VERSION = '7.4'

  # Check php-fpm service
  describe service("php#{PHP_VERSION}-fpm") do
    it { should be_enabled }
    it { should be_running }
  end

  # Check composer
  describe command('composer -V') do
    its(:stdout) { should include('Composer') }
    its(:stdout) { should include('version') }
  end

  # Check default opcache / xdebug setup
  describe command('php -v') do
    its(:stdout) { should include("PHP #{PHP_VERSION}") }
    its(:stdout) { should include('with Zend OPcache') }
    its(:stdout) { should_not include('with Xdebug') }
  end

  # Check default CLI configs / errors
  describe command('php -i') do
    its(:stderr) { should_not include('NOTICE') }
    its(:stderr) { should_not include('WARNING') }
    its(:stderr) { should_not include('ERROR') }
  end

  # Check default FPM configs / errors
  describe command("php-fpm#{PHP_VERSION} -i") do
    its(:stdout) { should include('opcache.enable => On => On') }
    its(:stdout) { should include('opcache.enable_cli => Off => Off') }
    its(:stderr) { should_not include('NOTICE') }
    its(:stderr) { should_not include('WARNING') }
    its(:stderr) { should_not include('ERROR') }
  end

  # Commands from README.md for enabling / disabling xdebug
  # Note that the commands below change state of DevVM before packaging the .box file.
  # In positive case, if the tests below pass, they should leave the system in original
  # state (xdebug disabled)
  describe command("phpenmod -v #{PHP_VERSION} -s cli xdebug; phpenmod -v #{PHP_VERSION} -s fpm xdebug && service php#{PHP_VERSION}-fpm restart && php -v") do
    its(:stdout) { should include('with Xdebug') }
  end
  describe command("phpdismod -v #{PHP_VERSION} -s cli xdebug; phpdismod -v #{PHP_VERSION} -s fpm xdebug; service php#{PHP_VERSION}-fpm restart; php -v") do
    its(:stdout) { should_not include('with Xdebug') }
  end

end
