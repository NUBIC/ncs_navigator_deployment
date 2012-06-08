include_attribute "apache2"
include_attribute "tomcat"

# Keep this in sync with the attributes below.  There should be one key-value
# pair for each application configuration.
#
# Applications that have configuration but do not appear in this map will not
# be configured.
set[:ncs_navigator][:apps] = {
  # name             # deployment type
  'core'         => 'apache/passenger.conf.erb',
  'psc'          => 'apache/tomcat.conf.erb',
  'staff_portal' => 'apache/passenger.conf.erb'
}

default[:ncs_navigator][:core][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/ncs_navigator_core"
default[:ncs_navigator][:psc][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/psc"
default[:ncs_navigator][:staff_portal][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/ncs_staff_portal"

default[:ncs_navigator][:core][:root] = "/var/www/apps/ncs_navigator_core"
default[:ncs_navigator][:staff_portal][:root] = "/var/www/apps/ncs_staff_portal"

default[:ncs_navigator][:core][:user] = "ncs_navigator_core"
default[:ncs_navigator][:psc][:user] = node[:tomcat][:user]
default[:ncs_navigator][:staff_portal][:user] = "ncs_staff_portal"

default[:ncs_navigator][:devenv][:urls] = {
  "core" => "https://navigator.#{node[:hostname]}.local",
  "psc" => "https://navcal.#{node[:hostname]}.local",
  "staff_portal" => "https://staffportal.#{node[:hostname]}.local"
}
