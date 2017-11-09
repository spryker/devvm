# Helpers
def colorize(text, color_code); "#{color_code}#{text}\033[0m"; end
def red(text); colorize(text, "\033[31m"); end
def yellow(text); colorize(text, "\033[33m"); end
def green(text); colorize(text, "\033[32m"); end
def bold(text); colorize(text, "\033[1;97m"); end

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
  VM_IP_PREFIX = ENV['VM_IP_PREFIX'] || '10.10.0.'                         # Prefix for IP address of DEV VM
  VM_IP        = ENV['VM_IP']        || VM_IP_PREFIX + unique_byte         # IP Address of the DEV VM, must be unique
  VM_MEMORY    = ENV['VM_MEMORY']    || '3200'                             # Amount of memory for DEV VM, in MB
  VM_CPUS      = ENV['VM_CPUS']      || '4'                                # Amount of CPU cores for DEV VM
  VM_NAME      = ENV['VM_NAME']      || "Spryker Dev VM (#{VM_PROJECT})"   # Visible name in VirtualBox
  VM_SKIP_SF   = ENV['VM_SKIP_SF']   || '0'                                # Don't mount shared folders
  VM_STORES    = (ENV['VM_STORES'] || 'de,at,us').split(',')               # Hostnames to be managed

  config=
    "VM_PROJECT =         '#{VM_PROJECT}'\n" +
    "VM_IP =              '#{VM_IP}'\n" +
    "VM_MEMORY =          '#{VM_MEMORY}'\n" +
    "VM_CPUS =            '#{VM_CPUS}'\n" +
    "VM_NAME =            '#{VM_NAME}'\n" +
    "VM_STORES =          '#{VM_STORES.join(',')}'\n" +
    "VM_SKIP_SF =         '#{VM_SKIP_SF}'\n" +
    "SPRYKER_BRANCH =     '#{SPRYKER_BRANCH}'\n" +
    "SPRYKER_REPOSITORY = '#{SPRYKER_REPOSITORY}'\n"

  unless (ARGV & ['up', 'reload', 'provision']).empty?
    puts yellow "New VM settings will be used:"
    puts config
    puts bold "Press return to save it in file .vm, Ctrl+C to abort"
    puts "If the settings above are fine, they will be persisted on disk."
    puts "To change any setting, interrupt now and set environmental variable."
    STDIN.gets
    File.write(VM_SETTINGS_FILE, config)
  end
end

# Backward compatibility for .vm file
VM_SKIP_SF = '0' if not defined? VM_SKIP_SF

# Remote locations of provisioning repositories
SALT_REPOSITORY    = ENV['SALT_REPOSITORY']    || "git@github.com:spryker/saltstack.git"
SALT_BRANCH        = ENV['SALT_BRANCH']        || "master"
PILLAR_REPOSITORY  = ENV['PILLAR_REPOSITORY']  || "git@github.com:spryker/pillar.git"
PILLAR_BRANCH      = ENV['PILLAR_BRANCH']      || "master"

HOSTS = []
['', '-test'].each do |host_suffix|
  domain = VM_PROJECT + '.local'
  VM_STORES.each do |store|
    HOSTS.push [ "www#{host_suffix}.#{store}.#{domain}", "zed#{host_suffix}.#{store}.#{domain}",]
  end
  HOSTS.push [ "static#{host_suffix}.#{domain}" ]
end

###
### END OF CONFIGURATION
###

# Check whether we are running UNIX or Windows-based machine
if Vagrant::Util::Platform.windows?
  HOSTS_PATH = 'c:\WINDOWS\system32\drivers\etc\hosts'
  IS_WINDOWS = true
  IS_UNIX = false
  IS_LINUX = false
  IS_OSX = false
  SYNCED_FOLDER_OPTIONS = { type: 'virtualbox' }
else
  HOSTS_PATH = '/etc/hosts'
  IS_WINDOWS = false
  IS_UNIX = true
  if (/darwin/ =~ Vagrant::Util::Platform.platform)
    IS_LINUX = false
    IS_OSX = true
    SYNCED_FOLDER_OPTIONS = { type: 'nfs' }
  else
    IS_LINUX = true
    IS_OSX = false
    SYNCED_FOLDER_OPTIONS = { type: 'nfs', mount_options: ['nolock'] }
  end
end

# mkmf
require 'mkmf'
File.delete('mkmf.log') if File.exists?('mkmf.log') and not IS_WINDOWS

# Verify if salt/pillar directories are present
has_fresh_repos = false

if not Dir.exists?(SALT_DIRECTORY)
  if find_executable 'git'
    puts bold "Cloning SaltStack git repository..."
    system "git clone #{SALT_REPOSITORY} --branch #{SALT_BRANCH} '#{SALT_DIRECTORY}'"
    has_fresh_repos = true
  else
    raise "ERROR: Required #{SALT_DIRECTORY} could not be found and no git executable was found to solve this problem." +
    "\n\n\033[0m"
  end
end

if not Dir.exists?(PILLAR_DIRECTORY)
  if find_executable 'git'
    puts bold "Cloning Pillar git repository..."
    system "git clone #{PILLAR_REPOSITORY} --branch #{PILLAR_BRANCH} '#{PILLAR_DIRECTORY}'"
    has_fresh_repos = true
  else
    raise "ERROR: Required #{PILLAR_DIRECTORY} could not be found and no git executable was found to solve this problem." +
    "\n\n\033[0m"
  end
end

if has_fresh_repos
  puts yellow "Fresh repositories have been cloned. If you just cloned example repository, then please read README.md in salt repository"
  sleep 5
end

if defined?(SPRYKER_REPOSITORY) and not SPRYKER_REPOSITORY.empty? # Clone Spryker (if repository is given)
  # This line is giving exception: Message: TypeError: no implicit conversion of false into Array
  #if (not Dir.exists?(SPRYKER_DIRECTORY)) or Dir.entries(SPRYKER_DIRECTORY) - %w{ . .. }.empty? # Only clone if it's empty folder
  if (not Dir.exists?(SPRYKER_DIRECTORY))
    puts bold "Cloning Spryker git repository..."
    if find_executable 'git'
      system "git clone #{SPRYKER_REPOSITORY} --branch #{SPRYKER_BRANCH} '#{SPRYKER_DIRECTORY}'"
    else
      raise "ERROR: Required #{SPRYKER_DIRECTORY} could not be found and no git executable was found to solve this problem." +
      "\n\n\033[0m"
    end
  elsif not Dir.entries(SPRYKER_DIRECTORY).include? 'setup'
    raise "ERROR: The directory #{SPRYKER_DIRECTORY} isn't empty, yet it's not a clone of spryker repository!"
  end
else
  puts yellow "Spryker repository is not defined or empty in Vagrantfile - can't clone the repository..."
end

Vagrant.configure(2) do |config|
  # Base box for initial setup. Latest Debian (stable) is recommended.
  # Not that the box file should have virtualbox guest additions installed, otherwise shared folders will not work
  config.vm.box = "debian91_8"
  config.vm.box_url = "https://github.com/korekontrol/packer-debian9/releases/download/ci-8/debian91.box"
  config.vm.hostname = "spryker-vagrant"
  config.vm.boot_timeout = 300

  # Enable ssh agent forwarding
  config.ssh.forward_agent = true

  # The VirtualBox IP-address for the browser
  config.vm.network :private_network, ip: VM_IP

  # Port forwarding for services running on VM, does not work on Windows
  if not IS_WINDOWS
    config.vm.network "forwarded_port", guest: 1080,  host: 1080,  auto_correct: true   # Mailcatcher
    config.vm.network "forwarded_port", guest: 3306,  host: 3306,  auto_correct: true   # MySQL
    config.vm.network "forwarded_port", guest: 5432,  host: 5432,  auto_correct: true   # PostgreSQL
    config.vm.network "forwarded_port", guest: 5601,  host: 5601,  auto_correct: true   # Kibana
    config.vm.network "forwarded_port", guest: 10007, host: 10007, auto_correct: true   # Jenkins (development)
  end

  # install required, but missing dependencies into the base box
  config.vm.provision "shell", inline: "sudo apt-get install -qqy pkg-config python2.7-dev"

  # SaltStack masterless setup
  if Dir.exists?(PILLAR_DIRECTORY) && Dir.exists?(SALT_DIRECTORY)
    config.vm.synced_folder SALT_DIRECTORY,   "/srv/salt/",   SYNCED_FOLDER_OPTIONS
    config.vm.synced_folder PILLAR_DIRECTORY, "/srv/pillar/", SYNCED_FOLDER_OPTIONS
    config.vm.provision :salt do |salt|
      salt.minion_config = "salt_minion"
      salt.run_highstate = true
      salt.bootstrap_options = "-F -P -c /tmp"
    end
  else
    raise "ERROR: Salt (#{SALT_DIRECTORY}) or Pillar (#{PILLAR_DIRECTORY}) directory not found.\n\n\033[0m"
  end

  # add hosts to /etc/hosts
  if Vagrant.has_plugin? 'vagrant-hostmanager'
    puts bold "Configuring vagrant-hostmanager (#{HOSTS.count} hostnames)..."
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
    config.hostmanager.aliases = HOSTS
    config.vm.provision :hostmanager
    puts "Using vagrant-hostmanager to set hostnames: " + HOSTS.join(', ')
  else
    hosts_line = VM_IP + " " + HOSTS.join(' ')
    if not File.open(HOSTS_PATH).each_line.any? { |line| line.chomp == hosts_line }
      puts bold "Please add the following entries to your #{HOSTS_PATH} file: \n\033[0m"
      puts hosts_line
    end
  end

  # Share the application code with VM
  if not (VM_SKIP_SF == '1')
    config.vm.synced_folder SPRYKER_DIRECTORY, "/data/shop/development/current", SYNCED_FOLDER_OPTIONS
    if IS_UNIX
      config.nfs.map_uid = Process.uid
      config.nfs.map_gid = Process.gid
    end
  end

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
