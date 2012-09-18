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
include_recipe "apache2"
include_recipe "java"
include_recipe "ssl_certificates"
include_recipe "tomcat"

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

# The configuration base.
cas_bcsec_configuration node[:cas][:bcsec] do
  action :create
  file_mode 0444
  file_owner app_owner
end

template node[:cas][:properties] do
  mode 0444
  owner app_owner
  source "cas.properties.erb"
  variables(:bcsec_path => node[:cas][:bcsec])
end

# Use NetID authentication in non-development scenarios.
unless node["development"]
  aker_central "netid" do
    action :create
    user node[:aker][:netid][:user]
    password node[:aker][:netid][:password]
  end

  cas_bcsec_directive "cas_central" do
    action :create
    configuration node[:cas][:bcsec]
    key "central"
    value node[:aker][:central][:path]
  end

  cas_authority "cas_netid" do
    action :create
    authority :netid
    configuration node[:cas][:bcsec]
  end
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

# Point Tomcat at a custom keystore...
include_recipe "tomcat::custom_trust_store"

# ...and add our certificates' signers to it.
keystore_path = node["tomcat"]["keystore"]["path"]
keystore_password = node["tomcat"]["keystore"]["password"]
ca_path = node["ssl_certificates"]["ca_path"]

node["ssl_certificates"]["trust_chain"].each do |cert|
  java_keystore "import_#{cert}_into_tomcat_keystore" do
    action :import
    keystore keystore_path
    storepass keystore_password
    cert_file "#{ca_path}/#{cert}"
    cert_alias cert
    user node["tomcat"]["user"]

    notifies :restart, resources(:service => 'tomcat')
  end
end

if node[:development]
  include_recipe "cas::server_devenv"
end
