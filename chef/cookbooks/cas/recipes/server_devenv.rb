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
include_recipe "tomcat"

app_group = node[:tomcat][:group]
app_owner = node[:tomcat][:user]

# Insert the development cert into the trusted certificates list for Tomcat.
java_keystore "import_cas_devenv_into_tomcat_keystore" do
  action :import
  keystore node["tomcat"]["keystore"]["path"]
  storepass node["tomcat"]["keystore"]["password"]
  cert_file node["cas"]["apache"]["ssl"]["certificate"]
  cert_alias "cas_devenv"
  user node["tomcat"]["user"]
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
