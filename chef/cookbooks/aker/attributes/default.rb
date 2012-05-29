include_attribute 'application_users'

default[:aker][:central][:path] = "/etc/nubic/bcsec-prod.yml"
default[:aker][:central][:group] = node[:application_users][:group] || 'app'
default[:aker][:central][:cas][:base_url] = node[:cas][:base_url]
default[:aker][:central][:cas][:proxy_retrieval_url] = node[:cas][:proxy_retrieval_url]
default[:aker][:central][:cas][:proxy_callback_url] = node[:cas][:proxy_callback_url]
default[:aker][:central][:pers][:entry] = node[:pers][:bcdatabase][:entry]
default[:aker][:central][:pers][:group] = node[:pers][:bcdatabase][:group]
