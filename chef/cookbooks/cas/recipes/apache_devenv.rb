#
# Cookbook Name:: cas
# Recipe:: apache_devenv
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

include_recipe "apache2"

# Calculate CAS URLs.
host = "#{node[:hostname]}.local"
node[:cas][:base_url] = "https://#{host}/cas"
node[:cas][:proxy_callback_url] = "https://#{host}/cas-proxy-callback/receive_pgt"
node[:cas][:proxy_retrieval_url] = "https://#{host}/cas-proxy-callback/retrieve_pgt"

# Point the CAS server at the development SSL certificate and key.
node[:cas][:apache][:ssl][:certificate] = node[:cas][:devenv][:ssl][:certificate]
node[:cas][:apache][:ssl][:key] = node[:cas][:devenv][:ssl][:key]

# Reload CAS attributes.
node.save unless Chef::Config[:solo]

ruby_block "reload CAS attributes" do
  block do
    node.load_attribute_by_short_filename('default', 'cas')
  end
end

cert_file = node[:cas][:apache][:ssl][:certificate]
key_file = node[:cas][:apache][:ssl][:key]

# Install SSL material.
cookbook_file cert_file do
  cookbook "ssl_certificates"
  group node[:apache][:group]
  mode 0444
  owner node[:apache][:user]
  source "wildcard.local.crt"
end

cookbook_file key_file do
  cookbook "ssl_certificates"
  group node[:apache][:group]
  mode 0400
  owner node[:apache][:user]
  source "wildcard.local.key"
end
