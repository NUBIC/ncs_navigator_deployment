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
include_recipe "ssl_certificates"
include_recipe "tomcat"
include_recipe "application_user"
include_recipe "openssl"

user = node[:apache][:user]
group = node[:apache][:group]
app_group = node[:application_user][:group]
ajp_remote = "ajp://localhost:#{node[:tomcat][:ajp_port]}/"

include_recipe "apache2::mod_proxy_ajp"
include_recipe "apache2::mod_ssl"

extend Opscode::OpenSSL::Password

# The Rails apps need mod_xsendfile for asset pipeline support.
#
# The package-provided configuration file is removed because all it does is
# load the module, which is the job of the apache_module definition.
yum_package "mod_xsendfile"

file "#{node[:apache][:dir]}/conf.d/xsendfile.conf" do
  action :delete
end

apache_module "xsendfile"

# Generate session secrets for Core and Staff Portal.
%w(core staff_portal).each do |app|
  unless node[:ncs_navigator][app][:secret]
    node[:ncs_navigator][app][:secret] = secure_password(128)
  end
end

# Reload.
node.save unless Chef::Config[:solo]
node.load_attribute_by_short_filename('default', 'ncs_navigator')

node[:ncs_navigator][:apps].each do |app|
  config_src = node[:ncs_navigator][app][:web][:template]
  config_dest = node[:ncs_navigator][app][:web][:configuration]
  app_uri = URI(node[:ncs_navigator][app][:url]) if node[:ncs_navigator][app][:url]
  app_root = node[:ncs_navigator][app][:root]
  app_user = node[:ncs_navigator][app][:user]
  app_keys = node[:ncs_navigator][app][:ssh_keys]
  ssl_certificate = node[:ncs_navigator][app][:ssl][:certificate]
  ssl_certificate_chain = node[:ncs_navigator][app][:ssl][:certificate_chain]
  ssl_key = node[:ncs_navigator][app][:ssl][:key]
  secret = node[:ncs_navigator][app][:secret]

  if app_user
    # Make the user...
    application_user app_user do
      action :create
      groups node[:ncs_navigator][app][:user_groups] || []
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

  if config_src && config_dest
    template_variables = {
      :ajp_remote => ajp_remote,
      :app_root => app_root,
      :env => node[:ncs_navigator][:env],
      :host => app_uri.host,
      :ssl_certificate => ssl_certificate,
      :ssl_certificate_chain => ssl_certificate_chain,
      :ssl_key => ssl_key,
      :uri => app_uri,
      :secret_token_env_var => "#{app}_SECRET".upcase,
      :secret_token => secret
    }

    template config_dest do
      group group
      mode 0444
      owner user
      source config_src
      variables template_variables
    end

    apache_site File.basename(config_dest) do
      enable true
    end
  end
end

# Listens for trust store changes and restarts Apache if necessary.
service "restart_app_httpd_on_trust_store_change" do
  service_name "httpd"
  action :nothing

  subscribes :restart, resources(:script => "build_trust_chain_bundle")
end

# Set the default NCS Navigator environment.
#
# Secrets are set in this file (not in the Apache configuration) because they
# need to be present for things like Rake tasks in applications that initialize
# the application.
#
# We could use fake secret data here, but that gets confusing.
template "/etc/profile.d/ncs_navigator.sh" do
  mode 0644
  source "ncs_navigator.sh.erb"
  variables :env => node[:ncs_navigator][:env],
            :core_secret => node[:ncs_navigator][:core][:secret],
            :staff_portal_secret => node[:ncs_navigator][:staff_portal][:secret]
end

# Rewrite HTTP URLs as HTTPS URLs.
template "#{node[:apache][:dir]}/sites-available/https_redirect" do
  source "https_redirect.erb"
end

apache_module "rewrite"

apache_site "https_redirect"

# The default site defines rules for VirtualHost *:80, so make sure it's off.
apache_site "default" do
  enable false
end

# If we have a sampling units file, retrieve and deploy it.
if node[:ncs_navigator][:study_center][:sampling_units]
  include_recipe "ncs_navigator::sampling_units"
end

# Warehouse setup.
include_recipe "ncs_navigator::warehouse"

# Adjust Tomcat configuration for PSC.
include_recipe "ncs_navigator::psc"

# Deploy application logos.
include_recipe "ncs_navigator::logos"

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

# Log rotation.
include_recipe "ncs_navigator::app_log_rotation"

# NCS instruments setup.
include_recipe "ncs_navigator::instruments"

# Hosted data maintenance scripts setup.
include_recipe "ncs_navigator::hosted_data_scripts"

# Applications need to be able to read the machine accounts file.
file node[:ncs_navigator][:machine_accounts][:file] do
  mode 0440
  group app_group
end
