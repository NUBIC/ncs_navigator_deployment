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

include_recipe "aker::central"
include_recipe "tomcat"
include_recipe "apache2"
include_recipe "application_users"

app_owner = node[:tomcat][:user]

# Download and install the CAS server WAR.
remote_file "#{node[:tomcat][:webapp_dir]}/#{node[:cas][:script_name]}.war" do
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