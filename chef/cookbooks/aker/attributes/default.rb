include_attribute 'application_user'

default[:aker][:central][:path] = "/etc/nubic/bcsec-prod.yml"
default[:aker][:central][:group] = node[:application_user][:group] || 'app'
default[:aker][:central][:config] = {}
