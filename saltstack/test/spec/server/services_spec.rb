require 'spec_helper'

services = [
  # System Services
  'vboxadd-service',
  'cron',
  'ntp',
  'docker',
  # App services
  'postgresql',
  'mysql',
  'rabbitmq-server',
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
]

describe 'Inactive services' do
  dead_services.each do |service|
    describe service(service) do
      it { should_not be_running }
    end
  end
end
