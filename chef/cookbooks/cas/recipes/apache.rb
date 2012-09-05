#
# Cookbook Name:: cas
# Recipe:: apache
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

require 'uri'

include_recipe "apache2"
include_recipe "ssl_certificates"

# CAS attributes are affected by node configuration, which isn't applied
# until after the role attributes have taken effect.  As such, we have to
# reload CAS attributes here.
node.load_attribute_by_short_filename('default', 'cas')

cas = node[:cas]
sites_enabled = "#{node[:apache][:dir]}/sites-enabled"

raise "cas.apache.ssl.certificate must be set" unless cas[:apache][:ssl][:certificate]
raise "cas.apache.ssl.key must be set" unless cas[:apache][:ssl][:key]

# The location of the CAS server over AJP.
remote = "ajp://localhost:#{node[:tomcat][:ajp_port]}/#{cas[:script_name]}"

# We need mod_proxy_ajp and mod_ssl.
include_recipe "apache2::mod_proxy_ajp"
include_recipe "apache2::mod_ssl"

server_name = URI.parse(cas[:base_url]).host

# Set up the site.
template node[:cas][:apache][:configuration] do
  source "cas.conf.erb"
  mode 0444
  owner node[:apache][:user]
  group node[:apache][:group]
  variables(:document_root => cas[:apache][:document_root],
            :ssl_certificate => cas[:apache][:ssl][:certificate],
            :ssl_certificate_key => cas[:apache][:ssl][:key],
            :ssl_certificate_chain => cas[:apache][:ssl][:chain],
            :callback_script_name => cas[:callback][:script_name],
            :callback_app_path => cas[:callback][:app_path],
            :server_script_name => cas[:script_name],
            :server_remote => remote,
            :server_name => server_name,
            :callback_url => cas[:proxy_callback_url])

  notifies :restart, resources(:service => "apache2")
end

apache_site "cas" do
  enable true
end

# The default site defines rules for VirtualHost *:80, so make sure it's off.
apache_site "default" do
  enable false
end

apache_module "rewrite" do
  enable true
end

# Listens for trust store changes and restarts Apache if necessary.
service "restart_cas_httpd_on_trust_store_change" do
  service_name "httpd"
  action :nothing

  subscribes :restart, resources(:script => "build_trust_chain_bundle")
end

if node[:development]
  include_recipe "cas::apache_devenv"
end
