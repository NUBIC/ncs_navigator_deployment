#
# Cookbook Name:: ncs_navigator
# Provider:: app_db
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
  db_host = node["ncs_navigator"]["db"]["host"]
  db_name = new_resource.name
  password = new_resource.password
  username = new_resource.username

  postgresql_database db_name do
    action :create
    connection :host => db_host, :username => username, :password => password
  end
end

action :drop do
  db_host = node["ncs_navigator"]["db"]["host"]
  db_name = new_resource.name
  password = new_resource.password
  username = new_resource.username

  postgresql_database db_name do
    action :drop
    connection :host => db_host, :username => username, :password => password
  end
end
