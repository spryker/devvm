require 'spec_helper'

describe 'Kibana' do
  describe service('kibana') do
    it { should be_enabled }
    it { should be_running }
  end

  describe http_get(5601, 'localhost', '/app/kibana') do
    its(:body) { should match /Kibana/ }
    its(:body) { should match /good stuff/ }
  end
end
