#
# Cookbook Name:: ncs_navigator
# Recipe:: db_server
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

include_recipe "postgresql::server"
include_recipe "database"

connection_info = {
  :host => "localhost",
  :username => "postgres",
  :password => node[:postgresql][:password][:postgres]
}

# If we're using Zeroconf, then Chef won't pick up an FQDN for us.  In that
# case, we use hostname matching to determine whether we should build a
# database for a given app.  Otherwise, match on FQDN.
if node[:zeroconf]
  def applicable?(host)
    node[:fqdn] == host.sub(/\.local$/, '')
  end
else
  def applicable?(host)
    node[:fqdn] == host
  end
end

node[:ncs_navigator][:apps].each do |key, _|
  app = node[:ncs_navigator][key]
  databases = app[:databases] || { :db => app[:database] }.reject { |_, v| v.nil? }

  databases.values.each do |db|
    db_host_for_app = db[:host]

    next if !db_host_for_app || !applicable?(db_host_for_app)

    db_user = db[:username]
    db_name = db[:name]

    postgresql_database_user db_user do
      action :create
      connection connection_info
      password db[:password]
      options 'CREATEDB'
    end

    postgresql_database db_name do
      action :create
      connection connection_info
      owner db_user
    end
  end
end

include_recipe "ncs_navigator::db_monitoring"
