require 'spec_helper'

describe "Packages" do
  packages_absent = [
    'exim4',
    'apache2-bin',
    'apache2.2-bin',
    'php5-fpm',
    'php5-cli',
    'php5-common',
  ]

  packages_absent.each do |package|
    describe package(package) do
      it { should_not be_installed }
    end
  end
end
