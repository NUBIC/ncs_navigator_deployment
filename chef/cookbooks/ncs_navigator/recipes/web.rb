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
include_recipe "application_users"

user = node[:apache][:user]
group = node[:apache][:group]

%w(core staff_portal).each do |app|
  config = node[:ncs_navigator][app][:web][:configuration]
  app_uri = URI(node[:ncs_navigator][app][:url])
  app_root = node[:ncs_navigator][app][:root]
  app_user = node[:ncs_navigator][app][:user]
  app_group = node[:application_users][:group]

  directory app_root do
    owner app_user
    group app_group
    recursive true
  end

  template config do
    owner user
    group group
    source "apache_passenger.conf.erb"
    variables(:host => app_uri.host, :app_root => app_root)
  end

  apache_site File.basename(config) do
    enable true
  end
end
