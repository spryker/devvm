require 'spec_helper'

describe 'nginx' do
  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe command('/usr/sbin/nginx -T') do
    its(:stderr) { should include('test is successful') }
    its(:stdout) { should match(/server_name.*www.*de.*local/) }
    its(:stdout) { should match(/server_name.*zed.*de.*local/) }
  end
end
