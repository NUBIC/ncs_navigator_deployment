include_attribute 'application_users'

default[:aker][:central][:path] = "/etc/nubic/bcsec-prod.yml"
default[:aker][:central][:group] = node[:application_users][:group] || 'app'
