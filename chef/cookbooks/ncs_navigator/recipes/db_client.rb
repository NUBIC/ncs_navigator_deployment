#
# Cookbook Name:: ncs_navigator
# Recipe:: db_client
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

include_recipe "bcdatabase"
include_recipe "tomcat"

# Applications using bcdatabase.
node[:ncs_navigator][:apps].each do |key, _|
  group = node[:ncs_navigator][key][:database][:bcdatabase_group]
  config = node[:ncs_navigator][key][:database][:bcdatabase_config]

  next unless group && config

  username = node[:ncs_navigator][key][:database][:username]
  password = node[:ncs_navigator][key][:database][:password]
  host = node[:ncs_navigator][key][:database][:host]

  bcdatabase_config config do
    action :create
    adapter "postgresql"
    group group
    host host
    password password
    username username
  end
end

# PSC.
psc_db_config = node[:ncs_navigator][:psc][:database][:config_file]

directory ::File.dirname(psc_db_config) do
  action :create
  recursive true
end

psc_app_owner = node[:tomcat][:user]

psc_db_host = node[:ncs_navigator][:psc][:database][:host]
psc_db_name = node[:ncs_navigator][:psc][:database][:name]
psc_db_username = node[:ncs_navigator][:psc][:database][:username]
psc_db_password = node[:ncs_navigator][:psc][:database][:password]

template psc_db_config do
  source "psc_datasource.properties.erb"
  mode 0400
  owner psc_app_owner
  variables(:host => psc_db_host,
            :name => psc_db_name,
            :username => psc_db_username,
            :password => psc_db_password)
end
