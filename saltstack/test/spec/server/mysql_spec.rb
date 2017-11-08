require 'spec_helper'

describe 'MySQL' do
  credentials="-uroot --password=''"

  describe command("/usr/sbin/mysqld --version") do
    its(:stdout) { should include('Ver 5.7') }
  end

  describe command("mysql #{credentials} -e 'show databases'") do
    its(:stdout) { should include('DE_development_zed') }
    its(:stdout) { should include('DE_devtest_zed') }
    its(:stdout) { should include('US_development_zed') }
    its(:stdout) { should include('US_devtest_zed') }
  end
end
