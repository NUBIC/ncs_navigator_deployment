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

# Insert the development cert into the trusted certificates list for Tomcat.
java_keystore "import_cas_devenv_into_tomcat_keystore" do
  action :import
  keystore node["tomcat"]["keystore"]["path"]
  storepass node["tomcat"]["keystore"]["password"]
  cert_file node["cas"]["apache"]["ssl"]["certificate"]
  cert_alias "cas_devenv"
  user node["tomcat"]["user"]
end

default_auth_config = %Q{
users:
  user:
    password: user
}

# If we have no YAML configuration, add a default.
#
# World-writable configuration is usually a horrible idea, but developers
# should be able to freely edit this file, and the bad habits taught by
# prepending "sudo" to every command are even worse.
#
# TODO: pass in a list of users authorized to edit this file.  (Under Vagrant,
# it's just ["vagrant"].)
file node[:cas][:devenv][:static_authority][:path] do
  action :create_if_missing
  content default_auth_config
  mode 0777
end

# Add a development authority.
cas_authority "development_cas_authority" do
  action :create
  authority :static
  configuration node[:cas][:bcsec]
  static_file node[:cas][:devenv][:static_authority][:path]

  notifies :restart, :service => 'tomcat'
end
