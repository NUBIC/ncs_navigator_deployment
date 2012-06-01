#
# Cookbook Name:: cas
# Recipe:: tomcat-apache
#
# Copyright 2012, Northwestern University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "aker::central"
include_recipe "tomcat"
include_recipe "apache2"
include_recipe "application_users"

app_owner = node[:tomcat][:user]

# Download and install the CAS server WAR.
remote_file "#{node[:tomcat][:webapp_dir]}/#{node[:cas][:public_path]}.war" do
  source node[:cas][:war][:source]
  checksum node[:cas][:war][:checksum]
  owner app_owner

  notifies :restart, "service[tomcat]"
end

# Do database configuration for the CAS server.
include_recipe "cas::database"

# Set up configuration data for the CAS server.
directory node[:cas][:dir] do
  action :create
  owner app_owner
end

template node[:cas][:properties] do
  source "cas.properties.erb"
  owner app_owner
  variables(:bcsec_path => node[:cas][:bcsec])
end

# Configure Bcsec for the CAS server.
template node[:cas][:bcsec] do
  source "bcsec.rb.erb"
  owner app_owner
  variables(:central => node[:aker][:central][:path])
end

# Make the log directory...
directory File.dirname(node[:cas][:log]) do
  action :create
  owner app_owner
  recursive true
end

# ...and point the app at it.  (The CAS server requires that the log location
# be set as as a system property.)
ruby_block "set nubic.cas.logFile property" do
  block do
    option = "-Dnubic.cas.logFile=#{node[:cas][:log]}"

    unless node[:tomcat][:java_options].include?(option)
      node[:tomcat][:java_options] += (" " + option)
      node.save unless Chef::Config[:solo]
    end
  end

  # This is CentOS/RHEL-specific.  For Debian-based systems, change this to
  # /etc/default/tomcat6.
  notifies :create, "template[/etc/sysconfig/tomcat6]"
end

# Make sure mod_proxy_ajp and mod_ssl are both loaded.
include_recipe "apache2::mod_proxy_ajp"
include_recipe "apache2::mod_ssl"

# Proxy node[:cas][:public_path] to the Tomcat server...
site_config = "#{node[:apache][:dir]}/sites-available/nubic_cas.conf"
remote = "ajp://localhost:#{node[:tomcat][:ajp_port]}/#{node[:cas][:public_path]}"

template site_config do
  source "nubic_cas.conf.erb"
  variables(:public_path => node[:cas][:public_path],
            :remote => remote)
  owner node[:apache][:user]
  group node[:apache][:group]

  notifies :restart, "service[apache2]"
end

# ...and activate it.
link "#{node[:apache][:dir]}/sites-enabled/nubic_cas.conf" do
  to site_config
end
