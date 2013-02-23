#
# Cookbook Name:: ncs_navigator
# Recipe:: ops
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

include_recipe "application_user"
include_recipe "bcdatabase"
include_recipe "database"
include_recipe "passenger"
include_recipe "ssl_certificates"

ncs_rails_app 'ops'

# Database and corresponding user.
db_name = node["ncs_navigator"]["ops"]["db"]["name"]
db_user_name = node["ncs_navigator"]["ops"]["db"]["user"]["name"]
db_user_password = node["ncs_navigator"]["ops"]["db"]["user"]["password"]

ncs_navigator_db_user db_user_name do
  action :create
  password db_user_password
end

ncs_navigator_app_db db_name do
  action :create
  password db_user_password
  username db_user_name
end

# Set up database information in bcdatabase.
ncs_navigator_bcdatabase_config 'ops' do
  config_hash node["ncs_navigator"]["ops"]["db"]["bcdatabase"]
  database db_name
  password db_user_password
  pool_size node["ncs_navigator"]["ops"]["db"]["pool"]
  username db_user_name
end
