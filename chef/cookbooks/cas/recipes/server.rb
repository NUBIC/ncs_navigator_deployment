#
# Cookbook Name:: cas
# Recipe:: server
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

include_recipe "aker"
include_recipe "tomcat"
include_recipe "apache2"

app_owner = node[:tomcat][:user]
app_group = node[:tomcat][:group]

# CAS attributes are affected by node configuration, which isn't applied
# until after the role attributes have taken effect.  As such, we have to
# reload CAS attributes here.
node.load_attribute_by_short_filename('default', 'cas')

# Download and install the CAS server WAR.
remote_file "#{node[:tomcat][:webapp_dir]}/#{node[:cas][:script_name]}.war" do
  source node[:cas][:war][:source]
  checksum node[:cas][:war][:checksum]
  owner app_owner
  group app_group
  notifies :restart, "service[tomcat]"
end

# Do database configuration for the CAS server.
include_recipe "cas::database"

# Set up configuration data for the CAS server.
directory node[:cas][:dir] do
  action :create
  mode 0755
  owner app_owner
end

template node[:cas][:properties] do
  mode 0444
  owner app_owner
  source "cas.properties.erb"
  variables(:bcsec_path => node[:cas][:bcsec])
end

# Use NetID authentication.
aker_central "netid" do
  action :create
  user node[:netid][:user]
  password node[:netid][:password]
end

# Configure Bcsec for the CAS server.
template node[:cas][:bcsec] do
  mode 0444
  owner app_owner
  source "bcsec.rb.erb"
  variables(:central => node[:aker][:central][:path])
end

# Make the log directory...
directory File.dirname(node[:cas][:log]) do
  action :create
  mode 0755
  owner app_owner
  recursive true
end

# ...and point the app at it.  (The CAS server requires that the log location
# be set as as a system property.)
ruby_block "set nubic.cas.logFile property" do
  block do
    option = "-Dnubic.cas.logFile=#{node[:cas][:log]}"

    unless node[:tomcat][:java_options].include?(option)
      node[:tomcat][:java_options] += " " + option
      node.save unless Chef::Config[:solo]
    end
  end

  # This is CentOS/RHEL-specific.  For Debian-based systems, change this to
  # /etc/default/tomcat6.
  notifies :create, "template[/etc/sysconfig/tomcat6]"
end

if node.chef_environment =~ /development/
  include_recipe "cas::server_devenv"
end
