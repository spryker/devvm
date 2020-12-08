#!/usr/bin/env ruby
#
# Spryker - Application deployment
#
# author: Marek Obuchowicz
#


###
### Configuration parsing - global variables
###
(puts "\033[31m!!! FATAL: You must deploy as user root:\033[0m\nsudo #{$0}"; exit 1) if Process.euid != 0
if File.exists? "config.rb"; path_prefix="./"; else path_prefix="/etc/deploy/"; end

require path_prefix + 'config.rb'
require path_prefix + 'config_local.rb' if File.exists? (path_prefix + 'config_local.rb')
require path_prefix + 'functions.rb'

$ssh_wrapper_path = "/etc/deploy/ssh_wrapper.sh"
$ssh_keyfile_path = "/etc/deploy/deploy.key"
$deploy_tmp_dir = $deploy_dir + "/tmp"
$deploy_log = $deploy_dir + "/deploy.log"
$release_name = current_time_dirname
$deploy_source_dir = $deploy_tmp_dir + '/' + $release_name

ENV['LANG']=ENV['LC_ALL']=ENV['LC_CTYPE']='C'
mkdir_if_missing $deploy_tmp_dir
$exec_foreach_store = "deploy/exec_foreach_store"
$exec_default_store = "deploy/exec_default_store"

###
### SVN
###

if $scm_type == "svn"
  puts red "ERROR: SVN is not supported anymore for deployment, please use GIT"
  exit 1
end

###
### GIT
###

if $scm_type == "git" # If $scm_type is declared in config.rb as "git"
  def initialize_scm
    if (File.exist?($ssh_wrapper_path)) && (File.exists?($ssh_keyfile_path))
      put_status "Enabled SSH wrapper + keyfile for GIT"
      ENV['GIT_SSH'] = $ssh_wrapper_path
    else
      put_status "Using SSH AgentForwarding keys - SSH wrapper (#{$ssh_wrapper_path}) or keyfile (#{$ssh_keyfile_path}) not found."
    end
    clone_git_repository unless File.directory?($git_path)
    put_status "SCM: git pull (be patient...)"
    result = git_pull
    if !result
      puts red "GIT pull failed! Aborting deployment"
      puts "Please solve the git problem, then retry"
      exit 2
    end
    git_prune
  end

  def clone_git_repository # If git clone does not exist, clone from $original_git_url defined in config.rb
    put_status "Local Git repository does not exist. Cloning from Git origin"
    result = system "git clone #{$original_git_url} #{$git_path}"
    if !result
      puts red "GIT clone failed! Aborting deployment"
      puts "Please solve the git problem, then retry"
      exit 2
    end
  end

  def ask_scm_dir
    if not $parameters[:scmpath].nil?
      value = $parameters[:scmpath]
      return value
    end

    all_tags = ((git_list_tags).split("\n")).sort.reverse
    all_branches = ((git_list_branches).split("\n"))
    all_branches = ["master"] + (all_branches-["master"]) # Move master to the top
    if $environment == "production"
      selected_tag = choose_item_from_array("Select tag to deploy: ", all_tags.first(20))
      put_status "SCM: git checkout #{selected_tag}"
      system "cd #{$git_path}/ && git checkout -q -f #{selected_tag}"
      return selected_tag
    else
      branches = all_branches
      branches = all_branches + all_tags.first(10) if (defined?($allow_tags_on_staging))
      selected_branch = choose_item_from_array("Select branch to deploy: ", branches)
      return selected_branch
    end
  end

  def export_source_from_git(branch)
    put_status "SCM: git checkout #{branch}"
    result = system "cd #{$git_path}/ && git checkout -q -f #{branch}"
    if !result
      puts red "git checkout #{branch} failed! Aborting deployment"
      puts "Please solve the git problem, then retry"
      exit 3
    end
    system "cd #{$git_path}/ && git merge -q --ff-only origin/#{branch} || echo '--thats fine when deploying tags...'"
    put_status "Copying source files..."
    system "rsync -a --delete --exclude=.git #{$git_path} #{$deploy_source_dir}"
  end

  def rsync_source_from_git
    put_status "Exporting source code from local Git repository"
    system "rsync -a --delete --exclude=.git #{$git_path} #{$deploy_source_dir}"
  end
end

###
### Configuration of application
###

def create_deploy_vars_file
  tools_hosts = $jobs_hosts || [$tools_host]
  tools_host = tools_hosts[0]
  jobs_hosts = tools_hosts . join ' '

  File.open("#{$deploy_source_dir}/deploy/vars", "w") do |f|
    f.puts "# Deployment configuration variables"
    f.puts "# This file is generated automatically by deploy.rb, do not modify"
    f.puts ""
    f.puts "deploy_source_dir=\"#{$deploy_source_dir}\""
    f.puts "destination_release_dir=\"#{$destination_release_dir}\""
    f.puts "destination_current_dir=\"#{$destination_current_dir}\""
    f.puts "newrelic_api_key=\"#{$newrelic_api_key}\""
    f.puts "revision=\"#{$revision}\""
    f.puts "shared_dir=\"/data/shop/#{$environment}/shared\""
    f.puts "environment=\"#{$environment}\""
    f.puts "verbose=\"#{$parameters[:verbose]}\""
    f.puts "storage_dir=\"#{$storage_dir}/#{$environment}\"" unless $storage_dir.nil?
    f.puts "deploy_user=\"#{get_current_user}\""
    f.puts "stores=\"#{$stores.map { |a| a['store'] }.join " "}\"" unless $stores.nil?
    f.puts "admin_host=\"#{tools_host}\""
    f.puts "dwh_host=\"#{$dwh_host}\"" unless $dwh_host.nil?
    f.puts "scm_path=\"#{$scm_path}\""
    f.puts "jobs_hosts=\"#{jobs_hosts}\""
    f.puts "jobs_master=\"#{tools_host}\""
    f.puts "changelog=\"#{$changelog}\""
    $project_options.each { |o| f.puts o[:variable] + "=\"" + (o[:value].nil? ? "":o[:value]) + "\"" }
    f.puts ""
    f.puts "export APPLICATION_ENV=\"#{$environment}\""
  end
end

def create_deploy_stores_file
  File.open("#{$deploy_source_dir}/deploy/stores", "w") do |f|
    f.puts "# Deployment stores configuration"
    f.puts "# This file is generated automatically by deploy.rb, do not modify"
    f.puts ""
    val_locales=val_appdomains=val_stores=""
    if ($stores.nil?)
      val_stores = "DE"
      val_locales = "de_DE"
      val_appdomains = "00"
      stores_array_max=0
    else
      $stores.each do |store|
        val_stores += "#{store['store']} "
        val_locales += "#{store['locale']} "
        val_appdomains += "#{store['appdomain']} "
      end
      stores_array_max=($stores.count)-1
    end
    f.puts "stores=(#{val_stores.strip})"
    f.puts "locales=(#{val_locales.strip})"
    f.puts "appdomains=(#{val_appdomains.strip})"
    f.puts "stores_array_max=#{stores_array_max}"
    f.puts "environment=#{$environment}"
  end
end

def create_rev_txt
  return if $rev_txt_locations.nil?
  $rev_txt_locations.each do |appdir|
    File.open("#{$deploy_source_dir}/#{appdir}/rev.txt", "w") do |f|
      f.puts "Date: "+`date`
      f.puts "Path: #{$scm_path}"
      f.puts "Revision: #{$revision}"
      f.puts "Deployed by: #{get_current_user}"
    end
  end
end

# Get application code from scm (git) repository
def get_application_code
  case $scm_type
    when 'git' then
      export_source_from_git $scm_path
      $revision = git_get_revision
  end
end

# Build application code
def prepare_code
  put_status "Preparing application code"
  old_dir = Dir.getwd
  Dir.chdir $deploy_source_dir
  if File.exists? "deploy/prepare_code"
    script_name = "deploy/prepare_code"
  else
    script_name = "deploy/create_shared_links"
    puts yellow "Please rename deploy/create_shared_links to deploy/prepare_code  (workaround activated)"
  end
  system "chmod 755 deploy/*"
  result = system "#{$exec_foreach_store} #{$debug} #{script_name}"
  if !result
    puts red "Command failed. Aborting deployment."
    exit 1
  end
  Dir.chdir old_dir
end

def check_configuration
  put_status "Checking hosts"
  hosts = $app_hosts || $zed_hosts
  result = multi_ssh_exec!(hosts, "cd #{$destination_release_dir} && su #{$www_user} -c \"#{$exec_foreach_store} #{$debug} deploy/check_configuration\" ")
end

def configure_hosts
  put_status "Configuring hosts"

  hosts = $app_hosts || $zed_hosts
  result = multi_ssh_exec!(hosts, "cd #{$destination_release_dir} && su #{$www_user} -c \"#{$exec_foreach_store} #{$debug} deploy/configure_host\" ")
end

def check_for_migrations
  put_status "Checking for migrations"
  hosts = $jobs_hosts || [$tools_host]
  host = hosts[0]
  result = multi_ssh_exec(host, "cd #{$destination_release_dir} && su #{$www_user} -c \"#{$exec_foreach_store} #{$debug} deploy/check_for_migrations\" ", {:dont_display_failed => 1})
  return true # result
end

def perform_migrations
  put_status "Executing migrations"
  hosts = $jobs_hosts || [$tools_host]
  host = hosts[0]
  result = multi_ssh_exec!(host, "cd #{$destination_release_dir} && su #{$www_user} -c \"#{$exec_foreach_store} #{$debug} deploy/perform_migrations\" ")
end

def update_cdn
  put_status "Updating assets in CDN"
  hosts = $jobs_hosts || [$tools_host]
  host = hosts[0]
  result = multi_ssh_exec(host, "cd #{$destination_release_dir} && su #{$www_user} -c \"#{$exec_foreach_store} #{$debug} deploy/update_cdn\" ")
end

def initialize_database
  put_status "Initializing database"
  hosts = $jobs_hosts || [$tools_host]
  host = hosts[0]
  result = multi_ssh_exec!(host, "cd #{$destination_release_dir} && [ -f deploy/initialize_database ] && su #{$www_user} -c \"#{$exec_foreach_store} #{$debug} deploy/initialize_database\" ")
end

def initialize_search
  put_status "Initializing search"
  hosts = $jobs_hosts || [$tools_host]
  host = hosts[0]
  result = multi_ssh_exec!(host, "cd #{$destination_release_dir} && [ -f deploy/initialize_search ] && su #{$www_user} -c \"#{$exec_foreach_store} #{$debug} deploy/initialize_search\" ")
end

def activate_maintenance
  put_status "Activating maintenance mode"
  hosts = $web_hosts || $frontend_hosts || $zed_hosts
  result = multi_ssh_exec(hosts, "cd #{$destination_release_dir} && su #{$www_user} -c \"#{$exec_default_store} #{$debug} deploy/enable_maintenance\" ")
end

def deactivate_maintenance
  put_status "Dectivating maintenance mode"
  hosts = $web_hosts || $frontend_hosts || $zed_hosts
  result = multi_ssh_exec(hosts, "cd #{$destination_release_dir} && su #{$www_user} -c \"#{$exec_default_store} #{$debug} deploy/disable_maintenance\" ")
end

def activate_cronjobs
  put_status "Activating cronjobs"
  hosts = [$jobs_hosts.first] || [$tools_host]
  hosts = (hosts + [$dwh_host]).uniq if $use_dwh

  result = multi_ssh_exec(hosts, "cd #{$destination_release_dir} && su #{$www_user} -c \"#{$exec_default_store} #{$debug} deploy/enable_cronjobs\" ")

  # Legacy - Yves+Zed 1.0, run as root
  result = multi_ssh_exec($frontend_hosts, "cd #{$destination_release_dir} && [ -f deploy/enable_local_cronjobs ] && #{$exec_default_store} #{$debug} deploy/enable_local_cronjobs") unless $frontend_hosts.nil?
end

def deactivate_cronjobs
  put_status "Deactivating cronjobs"
  hosts = $jobs_hosts || [$tools_host]
  result = multi_ssh_exec(hosts, "cd #{$destination_release_dir} && su #{$www_user} -c \"#{$exec_default_store} #{$debug} deploy/disable_cronjobs\" ")

  # Legacy - Yves+Zed 1.0, run as root
  result = multi_ssh_exec($frontend_hosts, "cd #{$destination_release_dir} && [ -f deploy/disable_local_cronjobs ] && #{$exec_default_store} #{$debug} deploy/disable_local_cronjobs") unless $frontend_hosts.nil?
end

###
### KV-Store and Search-store reindexing
###

def reindex_kv
  put_status "Reindexing KV-store"
  hosts = $jobs_hosts || [$tools_host]
  host = hosts[0]
  script_name = "deploy/reindex_kv"
  result = multi_ssh_exec(host, "cd #{$destination_release_dir} && [ -f #{script_name} ] && su #{$www_user} -c \"#{$exec_foreach_store} #{$debug} #{script_name}\" ")
end

def reindex_search
  put_status "Reindexing Search-store"
  hosts = $jobs_hosts || [$tools_host]
  host = hosts[0]
  script_name = "deploy/reindex_search"
  result = multi_ssh_exec(host, "cd #{$destination_release_dir} && [ -f #{script_name} ] && su #{$www_user} -c \"#{$exec_foreach_store} #{$debug} #{script_name}\" ")
end

def ask_reindex
  if not $parameters[:reindex].nil?
    value = $parameters[:reindex]
    puts "Perform full reindex: #{value}"
    return value
  end
  if choose_item_from_array("Perform FULL KV/Search import? ", %w(yes no)) == "yes"
    if $environment == "production"
      puts red "Warning, this will cause downtime while performing reindex."
      return false if choose_item_from_array("Proceed anyway? ", %w(yes no)) != "yes"
    end
    return true
  end
  return false
end

###
### Source code distribution
###

def create_tarball(tarfile)
  put_status "Creating tarball: #{tarfile}"
  system "chown -R #{$www_user}:#{$www_group} #{$deploy_tmp_dir}"
  system "tar --dir #{$deploy_tmp_dir} -cpf #{tarfile} #{$release_name}"
  FileUtils.rm_rf "#{$deploy_tmp_dir}/#{$release_name}"
end

def distribute_tarball(tarfile)
  put_status "Distributing tarball"
  destination_tar_dir = $destination_dir + '/' + $environment + '/releases'
  hosts = $app_hosts || $zed_hosts
  multi_ssh_exec(hosts, "[ -d #{destination_tar_dir} ] || mkdir #{destination_tar_dir}")
  rsync_commands = []
  hosts.each do |host|
    rsync_commands.push "rsync -ra #{tarfile} #{$rsync_user}@#{host}:#{destination_tar_dir}/#{$environment}.tar"
  end
  multi_exec! rsync_commands

  put_status "Uncompressing tarballs"
  multi_ssh_exec(hosts, "rm -rf #{$destination_release_dir}")
  multi_ssh_exec!(hosts, "cd #{destination_tar_dir} && tar xf #{$environment}.tar")
  multi_ssh_exec!(hosts, "rm -f #{destination_tar_dir}/#{$environment}.tar")
end

def activate_release
  put_status "Activating new release"
  restart_fpm_command = "/etc/init.d/php7.1-fpm restart"
  web_hosts = $web_hosts || $zed_hosts
  app_hosts = $app_hosts || $zed_hosts
  app_only_hosts = app_hosts - web_hosts
  multi_ssh_exec!(web_hosts, "ln -bns #{$destination_release_dir} #{$destination_current_dir} && #{restart_fpm_command}")
  multi_ssh_exec!(app_only_hosts, "ln -bns #{$destination_release_dir} #{$destination_current_dir}")
end

def create_lockfile
  if File.exists? $lockfile
    puts red "! Warning: lockfile exists. Is another deployment in progress?"
    puts "To remove lockfile, execute:"
    puts "sudo rm -f #{$lockfile}"
    exit 1
  end
  FileUtils.touch $lockfile
end

def remove_lockfile
  FileUtils.rm_f $lockfile
end

###
### Notifications
###

def send_notifications_after
  put_status "Sending notifications after deployment"
  hosts = $jobs_hosts || [$tools_host]
  host = hosts[0]
  result = multi_ssh_exec(host, "cd #{$destination_release_dir} && [ -f deploy/send_notifications ] && deploy/send_notifications", {:dont_display_failed => 1})
  result = multi_ssh_exec(host, "cd #{$destination_release_dir} && [ -f deploy/send_notifications_after ] && deploy/send_notifications_after", {:dont_display_failed => 1})
end

###
### Menus
###

def display_main_menu
  case ARGV[0]
    when "deploy"
      $interactive = false
      put_status "Non-interactive: deploy"
      perform_deploy
    when "", nil
      choose do |menu|
        menu.prompt = "Choose an action: "
        menu.choice(:deploy, "Deploy application") { perform_deploy }
      end
    else
      put_error "Unknown command: #{ARGV[0]}"
      puts $opt_parser
      exit 1
  end
end

def ask_environment
  if not $parameters[:environment].nil?
    value = $parameters[:environment]
    puts "Using environment: #{value}"
    if $environments.index(value).nil?
      put_error "Unknown environment on this host: #{value}"
      exit 1
    end
    return value
  end
  choose_item_from_array("Deploy to environment: ", $environments)
end

###
### Main actions
###

def perform_deploy
  if (($project_options.select { |opt| opt[:variable] == "debug" }.first)[:value] == "true")
    puts yellow "### Enabled debugging for project task scripts"
    $debug = "bash -x"
  end

  initialize_scm
  $environment = ask_environment

  $destination_release_dir = $destination_dir + '/' + $environment + '/releases/' + $release_name
  $destination_current_dir = $destination_dir + '/' + $environment + '/current'
  tarfile = "#{$deploy_tmp_dir}/#{$environment}.tar"
  $lockfile = $deploy_dir + '/.lock.' + $environment

  # Deployment actions
  $scm_path = ask_scm_dir
  create_lockfile
  perform_full_import = ask_reindex
  ask_project_options
  get_application_code
  create_deploy_vars_file
  create_deploy_stores_file
  create_rev_txt
  prepare_code
  create_tarball tarfile
  distribute_tarball tarfile
  check_configuration
  configure_hosts
  have_migrations = check_for_migrations
  show_maintenance = true if have_migrations
  deactivate_cronjobs
  activate_maintenance if show_maintenance
  perform_migrations if have_migrations
  update_cdn
  deactivate_maintenance
  initialize_database
  initialize_search
  activate_release
  reindex_kv if perform_full_import
  reindex_search if perform_full_import
  activate_cronjobs
  send_notifications_after
  remove_lockfile
end

###
### Main
###

puts yellow "Spryker - #{$project_name}"
parse_commandline_parameters
display_main_menu
