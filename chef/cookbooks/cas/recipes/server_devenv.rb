#
# Cookbook Name:: cas
# Recipe:: server_devenv
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

include_recipe "cas::apache_devenv"
include_recipe "java"
include_recipe "tomcat"

app_group = node[:tomcat][:group]
app_owner = node[:tomcat][:user]
cert_file = node[:cas][:apache][:ssl][:certificate]
keytool = "#{node[:java][:java_home]}/bin/keytool"
trust_store = node[:cas][:devenv][:trust_store][:path]
trust_store_password = node[:cas][:devenv][:trust_store][:password]

# Build a trust store for CAS...
directory ::File.dirname(trust_store) do
  action :create
  group app_group
  owner app_owner
  recursive true
end

bash "build_cas_trust_store" do
  user app_owner
  group app_group
  code <<-END
  rm -f #{trust_store}
  yes | #{keytool} -import -file #{cert_file} -alias devenv -keystore #{trust_store} -storepass #{trust_store_password}
  END
end

# ...and point the Tomcat JRE at it.
java_opts = "-Djavax.net.ssl.trustStore=#{trust_store} -Djavax.net.ssl.trustStorePassword=#{trust_store_password}"

unless node[:tomcat][:java_options].include?(java_opts)
  node[:tomcat][:java_options] += " " + java_opts
  node.save unless Chef::Config[:solo]
end

ruby_block "rebuild Tomcat environment" do
  block { }

  notifies :create, resources(:template => "/etc/sysconfig/tomcat6")
  notifies :restart, resources(:service => "tomcat")
end

# Switch bcsec into static authority mode...
static_file = node[:cas][:devenv][:static_authority][:path]

directory ::File.dirname(node[:cas][:bcsec]) do
  owner app_owner
  group app_group
  recursive true
end

template node[:cas][:bcsec] do
  mode 0444
  owner app_owner
  group app_group
  source "bcsec_dev.rb.erb"
  variables(:static_file => static_file)

  notifies :restart, "service[tomcat]"
end

# ...and provide a default configuration file.
cookbook_file static_file do
  mode 0666
  owner app_owner
  group app_group
  source "static.yml"
end
