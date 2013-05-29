#
# Cookbook Name:: ncs_navigator
# Definition:: ncs_rails_app
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

define :ncs_rails_app, :additional_env_vars => {} do
  require 'uri'

  include_recipe "apache2"
  include_recipe "apache2::mod_ssl"
  include_recipe "apache2::mod_xsendfile"
  include_recipe "application_user"
  include_recipe "logrotate"

  extend NcsNavigator::FindOrGenerateKey

  app_key = params[:name]
  raise "You must specify an app key" unless app_key

  a = node["ncs_navigator"][app_key]
  raise "Unknown application #{app_key}" unless a

  # Make a user for the application.
  app_group = node["application_user"]["group"]
  groups = a["user"]["groups"]
  keys = a["user"]["ssh_keys"]
  user = a["user"]["name"]

  ncs_navigator_app_user user do
    action :create
    groups groups
    keys keys
  end

  # Generate session secret.  This is persisted on each node because it's easier
  # to keep track of resources on the node than it is to make Chef Solo and Chef
  # Server work properly with attribute updates.
  secret_path = a["session_secret"]["path"]
  secret = find_or_generate_key(a["session_secret"]["path"], 128)

  # Secrets are set in this file (and in the Apache configuration) because they
  # need to be present for things like Rake tasks in applications that initialize
  # the application.
  #
  # We could use fake secret data here, but that gets confusing.
  env = node["ncs_navigator"]["env"]
  secret_env_var = a["session_secret"]["env_var"]
  raise "Application environment not specified" if env.nil?

  template "/etc/profile.d/ncs_navigator_#{app_key}.sh" do
    mode 0444
    source "load_secret_into_env.sh.erb"
    variables(
      :secret => secret,
      :env => env,
      :secret_token_env_var => secret_env_var
    )
  end

  # Make the app root.
  #
  # Although the root and shared subdirectories are created by deploy setup
  # tasks, we build them here to ensure correct permissions for resources that
  # may create subdirectories in those paths.  (This also avoids the need to
  # run deploy:setup with elevated privileges.)
  app_root = a["app"]["root"]
  shared_path = a["app"]["shared_path"]

  [app_root, shared_path].each do |path|
    directory path do
      action :create
      recursive true
      owner user
      group app_group
    end
  end

  # Write the Apache configuration.
  app_url = a["app"]["url"]
  raise "Application URL not specified" if app_url.nil?

  apache_group = node["apache"]["group"]
  apache_user = node["apache"]["user"]
  app_root = a["app"]["root"]
  min_instances = a["app"]["min_instances"]
  ssl_certificate = a["ssl"]["certificate"]
  ssl_certificate_chain = a["ssl"]["certificate_chain"]
  ssl_key = a["ssl"]["key"]

  config_dest = "#{node["apache"]["dir"]}/sites-available/ncs_navigator_#{app_key}"

  template config_dest do
    source "apache/passenger.conf.erb"
    mode 0444
    owner apache_user
    group apache_group
    variables(
      :app_root => app_root,
      :env => env,
      :host => URI(app_url).host,
      :min_instances => min_instances,
      :secret_token_env_var => secret_env_var,
      :secret_token => secret,
      :ssl_certificate_chain => ssl_certificate_chain,
      :ssl_certificate => ssl_certificate,
      :ssl_key => ssl_key,
      :uri => app_url,
      :additional_env_vars => params[:additional_env_vars]
    )

    notifies :reload, resources(:service => 'apache2')
  end

  service "restart_#{app_key}_httpd_on_trust_store_change" do
    service_name "httpd"
    action :nothing

    subscribes :restart, resources(:script => "build_trust_chain_bundle")
  end

  # Set up log rotation.
  app_user = a["user"]["name"]
  app_old_log_dir = a["old_log_path"]

  directory app_old_log_dir do
    group app_group
    mode 0755
    owner app_user
    recursive true
  end

  logrotate_app "ncs_navigator_#{app_key}" do
    create "644 #{app_user} #{app_group}"
    olddir app_old_log_dir
    path "#{app_log_dir}/*.log"
  end

  # Monitor the app host.
  monitrc "monitor_apache2", :pid => node["apache"]["pid_file"]

  # Monitor the app's status endpoint.
  monitrc "monitor_ncs_navigator_#{app_key}",
    :uri => URI(app_url),
    :endpoint => a["status_endpoint"]

  # Set up authentication services.
  include_recipe "ncs_navigator::auth"

  # Install gem dependencies.
  include_recipe "ncs_navigator::gem_dependencies"

  # Enable the app.
  apache_site File.basename(config_dest)
end
