require 'spec_helper'

describe 'Filesystems' do
  describe file('/') do
     it { should be_mounted.with( :type => 'ext4' ) }
  end

  describe file('/data/shop/development/current') do
     it { should be_mounted }
  end
end
