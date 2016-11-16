require './helpers'
require 'mkmf'

unless find_executable 'git'
  abort red "ERROR: git executable was found."
end

# Cleanup mkmf log
File.delete('mkmf.log') if File.exists?('mkmf.log')

required_plugins = ['vagrant-vbguest', 'vagrant-hostmanager']
plugins_to_install = required_plugins.select { |plugin| !Vagrant.has_plugin? plugin }
unless plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(', ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort red "Installation of one or more plugins has failed. Aborting."
  end
end

###
### BEGINNING OF CONFIGURATION
###

# Local locations of reposities
BASE_DIRECTORY     = File.expand_path(File.dirname(__FILE__))
SALT_DIRECTORY     = BASE_DIRECTORY + "/saltstack"
PILLAR_DIRECTORY   = BASE_DIRECTORY + "/pillar"
SPRYKER_DIRECTORY  = BASE_DIRECTORY + "/project"
VM_SETTINGS_FILE   = BASE_DIRECTORY + "/.vm"

# Check if there is VM configuration already saved
if File.exists? VM_SETTINGS_FILE
  puts bold "Loading VM settings file: .vm"
  load(VM_SETTINGS_FILE)
  if ARGV.include? 'destroy'
    puts bold "Deleting VM settings file: .vm"
    File.delete(VM_SETTINGS_FILE)
  end
else
  # Project settings
  VM_PROJECT = ENV['VM_PROJECT'] || 'demoshop'                         # Name of the project
  SPRYKER_REPOSITORY = ENV['SPRYKER_REPOSITORY'] || "git@github.com:spryker/#{VM_PROJECT}.git"
  SPRYKER_BRANCH = ENV['SPRYKER_BRANCH']  || "master"
  unique_byte = (Digest::SHA256.hexdigest(VM_PROJECT).to_i(16).modulo(251)+3).to_s

  # Settings for the Virtualbox VM
  VM_IP      = ENV['VM_IP']      || '10.10.0.' + unique_byte           # IP Address of the DEV VM, must be unique
  VM_MEMORY  = ENV['VM_MEMORY']  || '3200'                             # Amount of memory for DEV VM, in MB
  VM_CPUS    = ENV['VM_CPUS']    || '4'                                # Amount of CPU cores for DEV VM
  VM_NAME    = ENV['VM_NAME']    || "Spryker Dev VM (#{VM_PROJECT})"   # Visible name in VirtualBox

  config=
    "VM_PROJECT =         '#{VM_PROJECT}'\n" +
    "VM_IP =              '#{VM_IP}'\n" +
    "VM_MEMORY =          '#{VM_MEMORY}'\n" +
    "VM_CPUS =            '#{VM_CPUS}'\n" +
    "VM_NAME =            '#{VM_NAME}'\n" +
    "SPRYKER_BRANCH =     '#{SPRYKER_BRANCH}'\n" +
    "SPRYKER_REPOSITORY = '#{SPRYKER_REPOSITORY}'\n"

  unless ARGV.include? 'destroy'
    puts yellow "New VM settings will be used:"
    puts config
    puts bold "Press return to save it in file .vm, Ctrl+C to abort"
    puts "If the settings above are fine, they will be persisted on disk."
    puts "To change any setting, interrupt now and set environmental variable."
    STDIN.gets
    File.write(VM_SETTINGS_FILE, config)
  end
end

# Remote locations of provisioning repositories
SALT_REPOSITORY    = ENV['SALT_REPOSITORY']    || "git@github.com:spryker/saltstack.git"
SALT_BRANCH        = ENV['SALT_BRANCH']        || "master"
PILLAR_REPOSITORY  = ENV['PILLAR_REPOSITORY']  || "git@github.com:spryker/pillar.git"
PILLAR_BRANCH      = ENV['PILLAR_BRANCH']      || "master"

# Hostnames to be managed
STORES = ['de']
HOSTS = []
['', '-test'].each do |host_suffix|
  domain = VM_PROJECT + '.local'
  STORES.each do |store|
    HOSTS.push [ "www#{host_suffix}.#{store}.#{domain}", "zed#{host_suffix}.#{store}.#{domain}",]
  end
  HOSTS.push [ "static#{host_suffix}.#{domain}" ]
end

###
### END OF CONFIGURATION
###

# Verify if salt/pillar directories are present
has_fresh_repos = false

unless Dir.exists?(SALT_DIRECTORY)
  puts bold "Cloning SaltStack git repository..."
  system "git clone #{SALT_REPOSITORY} --branch #{SALT_BRANCH} #{SALT_DIRECTORY}"
  has_fresh_repos = true
end

unless Dir.exists?(PILLAR_DIRECTORY)
  puts bold "Cloning Pillar git repository..."
  system "git clone #{PILLAR_REPOSITORY} --branch #{PILLAR_BRANCH} #{PILLAR_DIRECTORY}"
  has_fresh_repos = true
end

if has_fresh_repos
  puts yellow "Fresh repositories have been cloned. If you just cloned example repository, then please read README.md in salt repository"
  sleep 5
end

# Clone Spryker (if repository is given)
if defined?(SPRYKER_REPOSITORY)
  if Dir[SPRYKER_DIRECTORY + "/*"].empty? and not SPRYKER_REPOSITORY.empty?
    puts bold "Cloning Spryker git repository..."
    system "git clone #{SPRYKER_REPOSITORY} --branch #{SPRYKER_BRANCH} #{SPRYKER_DIRECTORY}"
  end
else
  puts yellow "Spryker repository is not defined in Vagrantfile - not cloning it..."
end

Vagrant.configure(2) do |config|
  # Base box for initial setup. Latest Debian (stable) is recommended.
  # Not that the box file should have virtualbox guest additions installed, otherwise shared folders will not work
  config.vm.box = "debian85_12"
  config.vm.box_url = "https://github.com/korekontrol/packer-debian8/releases/download/ci-12/debian85.box"
  config.vm.hostname = "spryker-vagrant"
  config.vm.boot_timeout = 300

  # Enable ssh agent forwarding
  config.ssh.forward_agent = true

  # The VirtualBox IP-address for the browser
  config.vm.network :private_network, ip: VM_IP

  # Port forwarding for services running on VM
  config.vm.network "forwarded_port", guest: 1080,  host: 1080,  auto_correct: true   # Mailcatcher
  config.vm.network "forwarded_port", guest: 3306,  host: 3306,  auto_correct: true   # MySQL
  config.vm.network "forwarded_port", guest: 5432,  host: 5432,  auto_correct: true   # PostgreSQL
  config.vm.network "forwarded_port", guest: 10007, host: 10007, auto_correct: true   # Jenkins (development)

  # install required, but missing dependencies into the base box
  config.vm.provision "shell", inline: "sudo apt-get install -qqy pkg-config python2.7-dev"

  # SaltStack masterless setup
  if Dir.exists?(PILLAR_DIRECTORY) && Dir.exists?(SALT_DIRECTORY)
    config.vm.synced_folder SALT_DIRECTORY,   "/srv/salt/",   { type: 'virtualbox', type: 'nfs', mount_options: ['nolock'] }
    config.vm.synced_folder PILLAR_DIRECTORY, "/srv/pillar/", { type: 'virtualbox', type: 'nfs', mount_options: ['nolock'] }
    config.vm.provision :salt do |salt|
      salt.minion_config = "salt_minion"
      salt.run_highstate = true
      salt.bootstrap_options = "-F -P -c /tmp"
    end
  else
    abort yellow "ERROR: Salt (#{SALT_DIRECTORY}) or Pillar (#{PILLAR_DIRECTORY}) directory not found."
  end

  # add hosts to /etc/hosts
  puts bold "Configuring vagrant-hostmanager (#{HOSTS.count} hostnames)..."
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.hostmanager.aliases = HOSTS
  config.vm.provision :hostmanager
  puts "Using vagrant-hostmanager to set hostnames: " + HOSTS.join(', ')

  # Share the application code with VM
  config.vm.synced_folder SPRYKER_DIRECTORY, "/data/shop/development/current", { type: 'virtualbox', type: 'nfs', mount_options: ['nolock'] }
  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid

  # Configure VirtualBox VM resources (CPU and memory)
  config.vm.provider :virtualbox do |vb|
    vb.name = VM_NAME
    vb.customize([
      "modifyvm", :id,
      "--memory", VM_MEMORY,
      "--cpus", VM_CPUS,
    ])
  end
end
