require 'spec_helper'

describe 'Jenkins' do
  describe service('jenkins') do
    it { should_not be_running }
  end

  describe service('jenkins-development') do
    it { should be_enabled }
    it { should be_running }
  end

  describe http_get(10007, 'localhost', '/') do
    its(:body) { should match /Jenkins ver. 1/ }
    its(:body) { should match /Manage Jenkins/ }
  end
end
