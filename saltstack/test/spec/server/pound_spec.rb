require 'spec_helper'

describe 'Pound' do

  describe service('pound') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(443) do
    it { should be_listening }
  end

end
