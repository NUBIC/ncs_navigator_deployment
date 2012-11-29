#
# Cookbook Name:: ncs_navigator
# Recipe:: warehouse
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

include_recipe "application_user"

# Build the warehouse's logging directory.
directory node[:ncs_navigator][:warehouse][:log][:dir] do
  group node[:application_user][:group]
  mode 0770
  owner node[:ncs_navigator][:warehouse][:user]
  recursive true
end

# Deploy the base configuration file for import.
config_dir = node[:ncs_navigator][:warehouse][:config][:dir]
env = node[:ncs_navigator][:env]

directory config_dir do
  group node[:application_user][:group]
  mode 0770
  owner node[:ncs_navigator][:warehouse][:user]
  recursive true
end
