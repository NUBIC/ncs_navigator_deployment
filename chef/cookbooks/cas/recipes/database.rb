#
# Cookbook Name:: cas
# Recipe:: database
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "bcdatabase"
include_recipe "database"
include_recipe "postgresql::server"

connection_info = {
  :host => "localhost",
  :username => "postgres",
  :password => node[:postgresql][:password][:postgres]
}

db_name = node[:cas][:database][:name]
db_user = node[:cas][:database][:user]
db_pass = node[:cas][:database][:password] || secure_password

bcdb_group = node[:cas][:database][:bcdatabase][:group]

if !node[:cas][:database][:password]
  node[:cas][:database][:password] = db_pass
  node.save unless Chef::Config[:solo]
end

postgresql_database_user db_user do
  action :create
  password db_pass
  connection connection_info
end

postgresql_database db_name do
  action :create
  connection connection_info
  owner db_user
end

bcdatabase_config db_name do
  action :create
  group bcdb_group
  password db_pass
  username db_user
  url "jdbc:postgresql://localhost/#{db_name}"
end
