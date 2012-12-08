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
  app = node[:ncs_navigator][key]
  databases = app[:databases] || { :db => app[:database] }.reject { |_, v| v.nil? }

  databases.values.each do |db|
    group = db[:bcdatabase_group]
    config = db[:bcdatabase_config]

    next unless group && config

    username = db[:username]
    password = db[:password]
    host = db[:host]
    pool_size = db[:pool]

    bcdatabase_config "#{group}_#{config}" do
      action :create
      config config
      adapter "postgresql"
      datamapper_adapter "postgres"
      group group
      host host
      password password
      username username

      if pool_size
        pool pool_size
      end
    end
  end
end

# Build Redis configuration for Core.
bcdatabase_config "redis_for_core" do
  action :create
  config node[:ncs_navigator][:core][:redis][:bcdatabase_config]
  group node[:ncs_navigator][:core][:redis][:bcdatabase_group]
  host node[:ncs_navigator][:core][:redis][:host]
  port node[:ncs_navigator][:core][:redis][:port]
  db node[:ncs_navigator][:core][:redis][:db]
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

# The application suite should only have one database hostname, so pick one
# and write it as the default.  Right now, we use Core.
#
# This can get confusing with multiple DB hosts, but we'll deal with that
# when the time comes.
db_host = node[:ncs_navigator][:core][:database][:host]

template "/etc/profile.d/postgresql.sh" do
  source "postgresql.sh.erb"
  variables :host => db_host
  mode 0644
end
