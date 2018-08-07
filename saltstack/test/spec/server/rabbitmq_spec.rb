require 'spec_helper'

describe 'rabbitmq' do
  # Check service status
  describe service('rabbitmq-server') do
    it { should be_enabled }
    it { should be_running }
  end

  # Check if service is listening on AMQP-0-9-1 port
  describe port(5672) do
    it { should be_listening }
  end

  # Check if service is listening on HTTP API port
  describe port(15672) do
    it { should be_listening }
  end

  # Validate vhosts
  describe command('/usr/sbin/rabbitmqctl list_vhosts') do
    its(:stdout) { should include('/DE_development_zed') }
    its(:stdout) { should include('/DE_devtest_zed') }
  end

  # Validate users
  describe command('/usr/sbin/rabbitmqctl list_users') do
    its(:stdout) { should match(/admin *\[administrator\]/) }
    its(:stdout) { should include('/DE_development') }
    its(:stdout) { should include('/DE_testing') }
  end
end
