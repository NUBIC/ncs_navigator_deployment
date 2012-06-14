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

# Applications.
#
# Special notes:
#
# Don't add a user for PSC
# ------------------------
# PSC has an application user (tomcat), but the user is managed by the tomcat
# package and cookbook.  There's a possibility that the Tomcat server will be
# running when we attempt to set up tomcat as an application user, which won't
# work, as usermod etc. error out when processes are running as a given user.
#
#
# PSC doesn't use bcdatabase
# --------------------------
# The omission of bcdatabase_* keys for PSC is intentional.
#

default[:ncs_navigator][:env] = "production"

default[:ncs_navigator][:study_center][:sampling_units_file] = "/etc/nubic/ncs/ssu.csv"
default[:ncs_navigator][:study_center][:username] = "NetID"

default[:ncs_navigator][:core][:database][:bcdatabase_config] = "ncs_navigator_core"
default[:ncs_navigator][:core][:database][:bcdatabase_group] = "ncsdb_prod"
default[:ncs_navigator][:core][:database][:name] = "ncs_navigator_core"
default[:ncs_navigator][:core][:database][:username] = "ncs_navigator_core"
default[:ncs_navigator][:core][:redis][:bcdatabase_config] = "ncs_navigator_core"
default[:ncs_navigator][:core][:redis][:bcdatabase_group] = "ncsredis_prod"
default[:ncs_navigator][:core][:redis][:db] = 0
default[:ncs_navigator][:core][:root] = "/var/www/apps/ncs_navigator_core"
default[:ncs_navigator][:core][:ssh_keys] = []
default[:ncs_navigator][:core][:user] = "ncs_navigator_core"
default[:ncs_navigator][:core][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/ncs_navigator_core"
default[:ncs_navigator][:psc][:database][:config_file] = "/etc/psc/datasource.properties"
default[:ncs_navigator][:psc][:database][:name] = "psc"
default[:ncs_navigator][:psc][:database][:username] = "psc"
default[:ncs_navigator][:psc][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/psc"
default[:ncs_navigator][:staff_portal][:database][:bcdatabase_config] = "ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:database][:bcdatabase_group] = "ncsdb_prod"
default[:ncs_navigator][:staff_portal][:database][:name] = "ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:database][:username] = "ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:root] = "/var/www/apps/ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:ssh_keys] = []
default[:ncs_navigator][:staff_portal][:user] = "ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:email_reminder] = false
default[:ncs_navigator][:staff_portal][:exception_recipients] = []
default[:ncs_navigator][:staff_portal][:google_analytics_number] = ""

default[:ncs_navigator][:ini][:path] = "/etc/nubic/ncs/navigator.ini"

default[:ncs_navigator][:smtp][:host] = "localhost"
default[:ncs_navigator][:smtp][:port] = 25
default[:ncs_navigator][:smtp][:starttls] = false

default[:ncs_navigator][:devenv][:urls] = {
  "core" => "https://navigator.#{node[:hostname]}.local",
  "psc" => "https://navcal.#{node[:hostname]}.local",
  "staff_portal" => "https://staffportal.#{node[:hostname]}.local"
}
