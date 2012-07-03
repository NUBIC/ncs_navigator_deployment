include_attribute "apache2"
include_attribute "tomcat"

# Keep this in sync with the attributes below.
#
# Applications that have configuration but do not appear in this map will not
# be configured.
set[:ncs_navigator][:apps] = %w(core psc staff_portal warehouse)

# Applications.
#
# Special notes:
#
# Stub out missing categories with a Mash
# ---------------------------------------
#
# The NCS MDES Warehouse doesn't currently have a Web interface, and therefore
# has no web or SSL configuration.  In situations like these, stub out the
# missing section with a Mash.
#
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

default[:ncs_navigator][:authority][:psc][:ca_file] = ""

default[:ncs_navigator][:study_center][:username] = "NetID"
default[:ncs_navigator][:study_center][:footer_logo_left][:checksum] = "2d288345f95e90c25a59068b6eab776c82ff6c555a80d41322ba203bccc9d524"
default[:ncs_navigator][:study_center][:footer_logo_left][:path] = "/var/www/apps/ncs_shared/footer_logo_left.png"
default[:ncs_navigator][:study_center][:footer_logo_left][:source] = "https://github.com/NUBIC/ncs_navigator_deployment/raw/51d699dd797fc0deb3371af25f5c49b9dce6a38b/logos/footer_left.png"
default[:ncs_navigator][:study_center][:footer_logo_right][:checksum] = "7583e308a380440b4cd47c0fcb7599113d81e499ccb78f50e303eaf34e8c5d2f"
default[:ncs_navigator][:study_center][:footer_logo_right][:path] = "/var/www/apps/ncs_shared/footer_logo_right.png"
default[:ncs_navigator][:study_center][:footer_logo_right][:source] = "https://github.com/NUBIC/ncs_navigator_deployment/raw/51d699dd797fc0deb3371af25f5c49b9dce6a38b/logos/footer_right.png"

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
default[:ncs_navigator][:core][:web][:template] = "apache/passenger.conf.erb"
default[:ncs_navigator][:core][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/ncs_navigator_core"
default[:ncs_navigator][:psc][:database][:config_file] = "/etc/psc/datasource.properties"
default[:ncs_navigator][:psc][:database][:name] = "psc"
default[:ncs_navigator][:psc][:database][:username] = "psc"
default[:ncs_navigator][:psc][:user] = "psc_deployer"
default[:ncs_navigator][:psc][:user_groups] = [node[:tomcat][:group]]
default[:ncs_navigator][:psc][:ssh_keys] = []
default[:ncs_navigator][:psc][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/psc"
default[:ncs_navigator][:psc][:web][:template] = "apache/tomcat.conf.erb"
default[:ncs_navigator][:staff_portal][:database][:bcdatabase_config] = "ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:database][:bcdatabase_group] = "ncsdb_prod"
default[:ncs_navigator][:staff_portal][:database][:name] = "ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:database][:username] = "ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:root] = "/var/www/apps/ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:ssh_keys] = []
default[:ncs_navigator][:staff_portal][:user] = "ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:web][:template] = "apache/passenger.conf.erb"
default[:ncs_navigator][:staff_portal][:web][:configuration] = "#{node[:apache][:dir]}/sites-available/ncs_staff_portal"
default[:ncs_navigator][:staff_portal][:email_reminder] = false
default[:ncs_navigator][:staff_portal][:exception_recipients] = []
default[:ncs_navigator][:staff_portal][:google_analytics_number] = ""

%w(mdes_warehouse_working mdes_warehouse_reporting mdes_import_working mdes_import_reporting).each do |warehouse_db|
  default[:ncs_navigator][:warehouse][:databases][warehouse_db][:name] = warehouse_db
  default[:ncs_navigator][:warehouse][:databases][warehouse_db][:username] = "ncs_mdes_warehouse"
  default[:ncs_navigator][:warehouse][:databases][warehouse_db][:bcdatabase_config] = warehouse_db
  default[:ncs_navigator][:warehouse][:databases][warehouse_db][:bcdatabase_group] = "ncsdb_prod"
end

default[:ncs_navigator][:warehouse][:log][:dir] = "/var/log/nubic/ncs/warehouse"
default[:ncs_navigator][:warehouse][:config][:dir] = "/etc/nubic/ncs/warehouse"
default[:ncs_navigator][:warehouse][:ssh_keys] = []
default[:ncs_navigator][:warehouse][:ssl] = Mash.new
default[:ncs_navigator][:warehouse][:user] = "ncs_mdes_warehouse"
default[:ncs_navigator][:warehouse][:web] = Mash.new

default[:ncs_navigator][:ini][:path] = "/etc/nubic/ncs/navigator.ini"

default[:ncs_navigator][:smtp][:host] = "localhost"
default[:ncs_navigator][:smtp][:port] = 25
default[:ncs_navigator][:smtp][:starttls] = false

default[:ncs_navigator][:devenv][:urls] = {
  "core" => "https://navigator.#{node[:hostname]}.local",
  "psc" => "https://navcal.#{node[:hostname]}.local",
  "staff_portal" => "https://staffportal.#{node[:hostname]}.local"
}
