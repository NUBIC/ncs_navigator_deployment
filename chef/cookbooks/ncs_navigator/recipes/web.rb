#
# Cookbook Name:: ncs_navigator
# Recipe:: web
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
include_recipe "tomcat"
include_recipe "application_user"

user = node[:apache][:user]
group = node[:apache][:group]
app_group = node[:application_user][:group]
ajp_remote = "ajp://localhost:#{node[:tomcat][:ajp_port]}"

include_recipe "apache2::mod_proxy_ajp"
include_recipe "apache2::mod_ssl"

node[:ncs_navigator][:apps].each do |app, strategy|
  config = node[:ncs_navigator][app][:web][:configuration]
  app_uri = URI(node[:ncs_navigator][app][:url])
  app_root = node[:ncs_navigator][app][:root]
  app_user = node[:ncs_navigator][app][:user]
  ssl_certificate = node[:ncs_navigator][app][:ssl][:certificate]
  ssl_key = node[:ncs_navigator][app][:ssl][:key]

  application_user app_user do
    action :create
  end

  if app_root
    directory app_root do
      owner app_user
      group app_group
      recursive true
    end
  end

  template_variables = {
    :ajp_remote => ajp_remote,
    :app_root => app_root,
    :host => app_uri.host,
    :ssl_certificate => ssl_certificate,
    :ssl_key => ssl_key,
    :uri => app_uri
  }

  template config do
    owner user
    group group
    source strategy
    variables template_variables
  end

  apache_site File.basename(config) do
    enable true
  end
end
