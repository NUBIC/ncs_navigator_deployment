#
# Cookbook Name:: ncs_navigator
# Recipe:: psc
#
# Copyright 2013, Northwestern University
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

require 'uri'

include_recipe "apache2"
include_recipe "apache2::mod_proxy_ajp"
include_recipe "application_user"
include_recipe "database"
include_recipe "tomcat"

extend Chef::ApplicationUser::Home

ajp_remote = "ajp://localhost:#{node["tomcat"]["ajp_port"]}/"

# Create PSC deployer user.
#
# The deployer user is placed in the Tomcat group so that it can write PSC WARs
# to the Tomcat webapps directory.
deployer_user = node["ncs_navigator"]["psc"]["user"]["name"]
groups = node["ncs_navigator"]["psc"]["user"]["groups"]
keys = node["ncs_navigator"]["psc"]["user"]["ssh_keys"]

ncs_navigator_app_user deployer_user do
  action :create
  groups groups + [node["tomcat"]["group"]]
  keys keys
end

# Write the Apache configuration.
apache_group = node["apache"]["group"]
apache_user = node["apache"]["user"]
host = URI(node["ncs_navigator"]["psc"]["url"]).host
ssl_certificate = node["ncs_navigator"]["psc"]["ssl"]["certificate"]
ssl_certificate_chain = node["ncs_navigator"]["psc"]["ssl"]["certificate_chain"]
ssl_key = node["ncs_navigator"]["psc"]["ssl"]["key"]

config_dest = "#{node["apache"]["dir"]}/sites-available/psc"

template config_dest do
  source "apache/tomcat.conf.erb"
  mode 0444
  owner apache_user
  group apache_group
  variables(
    :ajp_remote => ajp_remote,
    :host => host,
    :ssl_certificate => ssl_certificate,
    :ssl_certificate_chain => ssl_certificate_chain,
    :ssl_key => ssl_key
  )
end

apache_site File.basename(config_dest)

# Build PSC database.
db_user = node["ncs_navigator"]["psc"]["db"]["user"]["name"]
db_name = node["ncs_navigator"]["psc"]["db"]["name"]
db_user_password = node["ncs_navigator"]["psc"]["db"]["user"]["password"]

ncs_navigator_db_user db_user do
  action :create
  password db_user_password
end

ncs_navigator_app_db db_name do
  action :create
  username db_user
  password db_user_password
end

# Datasource configuration.
datasource_config_file = node["ncs_navigator"]["psc"]["db"]["config_file"]

directory File.dirname(datasource_config_file) do
  action :create
  recursive true
end

template datasource_config_file do
  source "psc_datasource.properties.erb"
  mode 0400
  owner node["tomcat"]["user"]
  variables(:host => node["ncs_navigator"]["db"]["host"],
            :name => db_name,
            :username => db_user,
            :password => db_user_password)
end

# Listens for trust store changes and restarts Apache if necessary.
service "restart_app_httpd_on_trust_store_change" do
  service_name "httpd"
  action :nothing

  subscribes :restart, resources(:script => "build_trust_chain_bundle")
end

# PSC requires larger-than-standard permgen and heaps.
ruby_block "adjust_tomcat_for_psc" do
  max_perm_size = node["ncs_navigator"]["psc"]["tomcat"]["max_perm_size"]
  max_heap_size = node["ncs_navigator"]["psc"]["tomcat"]["max_heap_size"]

  max_perm_size_opt = "-XX:MaxPermSize=#{max_perm_size}"
  max_heap_size_opt = "-Xmx#{max_heap_size}"

  block do
    # Strip existing -XX:MaxPermSize and -Xmx directives, and add in the
    # new ones
    cur_opts = node["tomcat"]["java_options"].split(/\s+/).reject do |opt|
      opt =~ /-XX:MaxPermSize=/ || opt =~ /-Xmx/
    end

    cur_opts << max_perm_size_opt
    cur_opts << max_heap_size_opt

    node["tomcat"]["java_options"] = cur_opts.join(' ')
    node.save unless Chef::Config["solo"]
  end

  notifies :create, resources(:template => "/etc/sysconfig/tomcat6")

  not_if do
    [max_perm_size_opt, max_heap_size_opt].all? { |opt| node["tomcat"]["java_options"].include?(opt) }
  end
end

# OSGi bundles need this.
#
# See https://code.bioinformatics.northwestern.edu/issues/wiki/psc/Deploying_plugins.
deployer_home = application_user_home(deployer_user)
psc_bundle_dir = "#{deployer_home}/psc"

app_group = node["application_user"]["group"]

%w(configurations libraries plugins).each do |dir|
  directory "#{psc_bundle_dir}/bundles/#{dir}" do
    recursive true
    owner deployer_user
    group app_group
    mode 0775
  end
end

# Make sure that all directories to the bundle directory are executable by
# Tomcat.  If they aren't, then PSC's bundle installer will (silently) fail.
execute "chgrp -R #{node["tomcat"]["group"]} #{deployer_home}"
execute "chmod -R 0750 #{deployer_home}"

# To avoid dumping large JARs under /etc/tomcat6 (which is the target of
# /usr/share/tomcat6/conf), we symlink /usr/share/tomcat6/conf/psc to
# psc_bundle_dir.
link "#{node["tomcat"]["base"]}/conf/psc" do
  to psc_bundle_dir
end

# PSC's CAS mechanism needs to be able to trust the CAS server, so install the
# CAS server's certificates in a trust store and point Tomcat at it.
include_recipe "tomcat::custom_trust_store"
include_recipe "ssl_certificates"

node["ssl_certificates"]["trust_chain"].each do |cert|
  cf = "#{node["ssl_certificates"]["ca_path"]}/#{cert}"

  java_keystore "add_nubic_certificates_for_psc" do
    action :import
    keystore node["tomcat"]["keystore"]["path"]
    storepass node["tomcat"]["keystore"]["password"]
    cert_file cf
    cert_alias cert

    notifies :restart, resources(:service => 'tomcat')
  end
end

# Put the tomcat user in the app group. This is necessary since PSC runs as the
# tomcat user and needs to read app-scoped resources like navigator.ini.
group node["application_user"]["group"] do
  append true
  members node["tomcat"]["user"]
end

# Monitor PSC.
monitrc "monitor_ncs_navigator_psc",
  :uri => URI(node["ncs_navigator"]["psc"]["url"]),
  :endpoint => node["ncs_navigator"]["psc"]["status_endpoint"]
