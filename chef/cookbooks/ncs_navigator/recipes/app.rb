#
# Cookbook Name:: ncs_navigator
# Recipe:: app
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
include_recipe "passenger"
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
  app_keys = node[:ncs_navigator][app][:ssh_keys]
  ssl_certificate = node[:ncs_navigator][app][:ssl][:certificate]
  ssl_key = node[:ncs_navigator][app][:ssl][:key]

  if app_user
    # Make the user...
    application_user app_user do
      action :create
      authorized_keys app_keys
    end

    # ..and set their Ruby environment to use the Ruby used by Passenger.
    # We do this so that application users use the same Ruby for maintenance
    # tasks and one-offs as they do for the main app.
    template "#{application_user_home(app_user)}/.bashrc" do
      source "bashrc.erb"
      mode 0444
      variables(:ruby => node[:passenger][:rvm_ruby_string])
    end

  end

  # Application configuration.
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

# Adjust Tomcat configuration for PSC.
include_recipe "ncs_navigator::psc"

# Build ncs_navigator.ini.
include_recipe "ncs_navigator::ini"

# Set up authentication services.
include_recipe "ncs_navigator::auth"

# Install dependencies for native extensions used by gems.
include_recipe "ncs_navigator::app_dependencies"

# Database connection.
include_recipe "ncs_navigator::db_client"

# Monitoring.
include_recipe "ncs_navigator::app_monitoring"