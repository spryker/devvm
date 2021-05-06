require 'spec_helper'

describe 'localhost:10021/' do
  describe http_get(10021, 'localhost', '/') do
    its(:status) { should eq 200 }
    its(:body) { should match /You Know, for Search/ }
  end
end

describe 'localhost:10021/_cluster/health' do
  describe http_get(10021, 'localhost', '/_cluster/health') do
      its(:status) { should eq 200 }
    its(:json) { should_not include('status' => /red/) }
  end
end
