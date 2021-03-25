require 'spec_helper'

describe 'nginx' do
  # Check service status
  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  # Check if NginX is listening on HTTP port
  describe port(80) do
    it { should be_listening }
  end

  # Validate NginX configuration
# describe command('/usr/sbin/nginx -T') do
#   its(:stderr) { should include('test is successful') }
#   its(:stdout) { should match(/server_name.*www.*de.*local/) }
#   its(:stdout) { should match(/server_name.*zed.*de.*local/) }
#   its(:stdout) { should match(/server_name.*glue.*de.*local/) }
#   its(:stdout) { should match(/server_name.*demo-date-time-configurator.*local/) }
#   its(:stdout) { should match(/server_name.*gateway.*local/) }
#   its(:stdout) { should match(/server_name.*zed-rest-api.*local/) }
# end
end
