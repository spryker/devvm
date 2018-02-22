require 'spec_helper'

describe 'php' do
  let(:path) { '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
  PHP_VERSION = '7.2'

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
    its(:stderr) { should_not include('NOTICE') }
    its(:stderr) { should_not include('WARNING') }
    its(:stderr) { should_not include('ERROR') }
  end

  # Commands from README.md for enabling / disabling xdebug
  describe command("phpenmod -v #{PHP_VERSION} -s cli xdebug; phpenmod -v #{PHP_VERSION} -s fpm xdebug && service php#{PHP_VERSION}-fpm restart && php -v") do
    its(:stdout) { should include('with Xdebug') }
  end
  describe command("phpdismod -v #{PHP_VERSION} -s cli xdebug; phpdismod -v #{PHP_VERSION} -s fpm xdebug; service php#{PHP_VERSION}-fpm restart; php -v") do
    its(:stdout) { should_not include('with Xdebug') }
  end

end
