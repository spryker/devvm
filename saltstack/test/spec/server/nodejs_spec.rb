require 'spec_helper'

describe 'nodejs' do
  describe command('/usr/bin/node -v') do
    its(:stdout) { should include('v8.') }
  end

  describe command('/usr/bin/yarn --version') do
    its(:stdout) { should include('1.') }
  end

  describe file('/opt/nvm/nvm.sh') do
    it { should be_readable ) }
  end

end
