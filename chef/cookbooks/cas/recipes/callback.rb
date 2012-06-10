#
# Cookbook Name:: cas
# Recipe:: callback
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
include_recipe "application_user"
include_recipe "passenger::apache2-rvm"

rvm_ruby_string = node[:passenger][:rvm_ruby_string]
rvm_exec = "#{node[:rvm][:root_path]}/bin/rvm #{rvm_ruby_string} exec"

# Install Aker.
gem_package "aker" do
  version node[:aker][:version]
  gem_binary "#{rvm_exec} gem"
end

app_path = node[:cas][:callback][:app_path]
app_user = node[:cas][:callback][:user]
app_group = node[:application_user][:group]
pgt_pstore_path = node[:cas][:callback][:pstore_path]

rackup_path = "#{node[:cas][:callback][:app_path]}/config.ru"

# Create a user for the callbacks.
application_user app_user do
  action :create
end

# Prepare a storage location for the callback's pstore.
directory ::File.dirname(pgt_pstore_path) do
  action :create
  group app_group
  owner app_user
  recursive true
end

# Generate Passenger-mandated bits.
directory "#{app_path}/tmp" do
  recursive true
  owner app_user
end

directory "#{app_path}/public" do
  recursive true
  owner app_user
end

template rackup_path do
  source "config.ru.erb"
  owner app_user
  variables(:pgt_pstore_path => pgt_pstore_path)
end

link "#{node[:cas][:apache][:document_root]}/#{node[:cas][:callback][:script_name]}" do
  to "#{app_path}/public"
end
