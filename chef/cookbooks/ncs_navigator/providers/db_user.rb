#
# Cookbook Name:: ncs_navigator
# Provider:: db_user
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

action :create do
  db_admin_password = node["ncs_navigator"]["db"]["admin"]["password"]
  db_admin_username = node["ncs_navigator"]["db"]["admin"]["user"]
  db_host = node["ncs_navigator"]["db"]["host"]
  password = new_resource.password
  username = new_resource.name

  raise "You need to set a password when creating a database user" unless password

  postgresql_database_user username do
    action :create
    connection :host => db_host, :username => db_admin_username, :password => db_admin_password
    password password
    options 'CREATEDB'
  end
end

action :drop do
  db_admin_password = node["ncs_navigator"]["db"]["admin"]["password"]
  db_admin_username = node["ncs_navigator"]["db"]["admin"]["user"]
  db_host = node["ncs_navigator"]["db"]["host"]
  username = new_resource.name

  postgresql_database_user username do
    action :drop
    connection :host => db_host, :username => db_admin_username, :password => db_admin_password
  end
end
