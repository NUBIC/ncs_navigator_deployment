#
# Cookbook Name:: ncs_navigator
# Recipe:: pancakes
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

require 'uri'

include_recipe "application_user"
include_recipe "bcdatabase"
include_recipe "database"

app_key = "pancakes"
app = node["ncs_navigator"][app_key]

ncs_rails_app app_key do
  additional_env_vars({
    'AKER_CENTRAL_PATH' => node["aker"]["central"]["path"],
    'NCS_NAVIGATOR_INI_PATH' => node["ncs_navigator"]["ini"]["path"],
    'OPS_URL' => node["ncs_navigator"]["ops"]["app"]["url"],
    'STUDY_LOCATIONS_PATH' => app["study_locations_path"],
    'QUERY_CONCURRENCY' => app["query_concurrency"],
    'USE_BCDATABASE_FOR_REDIS' => '1'
  })
end

# Database and corresponding user.
db_name = app["db"]["name"]
db_user_name = app["db"]["user"]["name"]
db_user_password = app["db"]["user"]["password"]

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
ncs_navigator_bcdatabase_config app_key do
  config_hash app["db"]["bcdatabase"]
  database db_name
  password db_user_password
  pool_size app["db"]["pool"]
  username db_user_name
end

# Redis configuration.
redis = app["redis"]

bcdatabase_config "redis_for_#{app_key}" do
  action :create
  config redis["bcdatabase"]["config"]
  group redis["bcdatabase"]["group"]
  host redis["host"]
  port redis["port"]
  db redis["db"]
end

# Configure Pancakes' study locations.
locs = node["ncs_navigator"]["locations"].map do |loc|
  { "name" => loc["name"], "url" => loc["url"] }
end

file app["study_locations_path"] do
  owner app["user"]["name"]
  group node["application_user"]["group"]
  content({ "study_locations" => locs }.to_json)
end

# Monitoring.
monitrc "monitor_pancakes_sidekiq",
  :pid => app["worker"]["pid"],
  :log => app["worker"]["log"],
  :concurrency => app["worker"]["concurrency"],
  :env => node["ncs_navigator"]["env"],
  :current_path => app["app"]["current_path"],
  :aker_central_path => node["aker"]["central"]["path"],
  :uid => app["user"]["name"],
  :gid => node["application_user"]["group"]

monitrc "monitor_pancakes_redis",
  :host => node["ncs_navigator"]["pancakes"]["redis"]["host"],
  :port => node["ncs_navigator"]["pancakes"]["redis"]["port"]
