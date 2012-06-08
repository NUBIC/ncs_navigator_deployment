include_attribute "apache2"

default[:ncs_navigator][:core][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/ncs_navigator_core"
default[:ncs_navigator][:psc][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/psc"
default[:ncs_navigator][:staff_portal][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/ncs_staff_portal"

default[:ncs_navigator][:core][:root] = "/var/www/apps/ncs_navigator_core"
default[:ncs_navigator][:staff_portal][:root] = "/var/www/apps/ncs_staff_portal"

default[:ncs_navigator][:core][:user] = "ncs_navigator_core"
default[:ncs_navigator][:staff_portal][:user] = "ncs_staff_portal"
