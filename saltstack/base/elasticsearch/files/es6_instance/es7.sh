#!/bin/bash
# After switching from ES7 to ES6 with es6.sh you could return to ES7 version with this script

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
info "This installer will switch back to Elasticsearch 7.x"
info "All data in Elasticsearch will be lost."
info "Press ENTER to continue..."
read something

info "------------------"
info "Stop Jenkins"
systemctl stop jenkins-devtest

info "Stop Kibana6 service"
systemctl stop kibana6

info "Stop elasticsearch6-development service"
systemctl stop elasticsearch6-development

info "Disable elasticsearch6-development service"
systemctl disable elasticsearch6-development

info "Disable Kibana6 service"
systemctl disable kibana6

info "Clear elasticsearch data in /data/shop/development/shared/elasticsearch"
rm -rf /data/shop/development/shared/elasticsearch/*

info "Enable elasticsearch-development service"
systemctl enable elasticsearch-development

info "Enable Kibana service"
systemctl enable kibana

info "Reload systemd"
systemctl daemon-reload

info "Start Elasticsearch 7.x"
systemctl start elasticsearch-development

info "Start Kibana 7.x"
systemctl start kibana

info "Start Jenkins"
systemctl start jenkins-development

info "Finished"
info "Please wait some seconds before starting using the ES service"
info "Export to ES should be triggered with command: vendor/bin/console search:setup"
