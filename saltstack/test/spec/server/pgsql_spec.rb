require 'spec_helper'

describe 'PostgreSQL' do
  ENV['PGPASSWORD'] = 'mate20mg'

  describe command("psql --user development --host 127.0.0.1 DE_development_zed -c \"SELECT * FROM pg_extension WHERE extname='citext'\"") do
    its(:stdout) { should include('1 row') }
  end

  describe command("psql --user development --host 127.0.0.1 DE_development_zed -c \"SELECT datname FROM pg_database WHERE datistemplate = false\"") do
    its(:stdout) { should include('DE_development_zed') }
    its(:stdout) { should include('DE_devtest_zed') }
    its(:stdout) { should include('US_development_zed') }
    its(:stdout) { should include('US_devtest_zed') }
  end
end
