require 'spec_helper'

services = [
  # System Services
  'vboxadd-service',
  'cron',
  'ntp',
  #'docker', # Temporarly disabled until docker containerd does not cause issues
  # App services
  'postgresql',
  'mysql',
  'redis-server-development',
  'elasticsearch-development',
]

describe 'Active services' do
  services.each do |service|
    describe service(service) do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

dead_services = [
  'redis-server',
  'elasticsearch',
  'jenkins',
  'filebeat',
]

describe 'Inactive services' do
  dead_services.each do |service|
    describe service(service) do
      it { should_not be_running }
    end
  end
end
