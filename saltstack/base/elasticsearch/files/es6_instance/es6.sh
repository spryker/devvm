#!/bin/bash
# After migration from ES6 to ES7, devvm is provided with ES7 (by default).
# This installer can be executed to run version 6.
# There is the way to return back to es7 with es7.sh script.

CONF_SOURCE=/opt/elasticsearch-6.8.6/config

function info() {
  echo -ne "\e[1m### "
  echo $*
  echo -ne "\e[0m"
}

if [[ $EUID != 0 ]]; then
  info "ERROR: You need to run this command with root privileges:"
  echo "sudo bash $0"
  exit 1
fi

info "------------------"
info "This installer will switch you currently installed Elasticsearch 7.x"
info "and run Elasticsearch 6.x. All data in Elasticsearch will be lost."
info "Press ENTER to continue..."
read something

info "------------------"
info "Stop Jenkins"
systemctl stop jenkins-devtest

info "Stop elasticsearch-development service"
systemctl stop elasticsearch-development

info "Clear elasticsearch data in /data/shop/development/shared/elasticsearch"
rm -rf /data/shop/development/shared/elasticsearch/*

info "Disable elasticsearch-development service"
systemctl disable elasticsearch-development

info "Enable elasticsearch6-development service"
systemctl enable elasticsearch6-development

info "Reload systemd"
systemctl daemon-reload

info "Start Elasticsearch 6.x"
systemctl start elasticsearch6-development

info "Start Jenkins"
systemctl start jenkins-development

info "Finished"
info "Please wait some seconds before starting using the ES service"
info "Export to ES should be triggered with command: vendor/bin/console search:setup"
