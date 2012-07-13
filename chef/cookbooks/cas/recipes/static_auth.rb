#
# Cookbook Name:: cas
# Recipe:: static_auth
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

raise "You must supply a configuration in cas.static_authority.config" if node[:cas][:static_authority][:config].empty?

include_recipe "tomcat"

app_group = node[:tomcat][:group]
app_owner = node[:tomcat][:user]
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

file static_file do
  mode 0444
  owner app_owner
  group app_group
  content node[:cas][:static_authority][:config]
end
