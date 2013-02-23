#
# Cookbook Name:: ncs_navigator
# Recipe:: warehouse
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

app_group = node["application_user"]["group"]
user = node["ncs_navigator"]["warehouse"]["user"]["name"]
groups = node["ncs_navigator"]["warehouse"]["user"]["groups"]
keys = node["ncs_navigator"]["warehouse"]["user"]["ssh_keys"]

# Make the warehouse user.
ncs_navigator_app_user user do
  action :create
  groups groups
  keys keys
end

# Create the warehouse database user.
study_center_short_name = node["ncs_navigator"]["cases"]["study_center"]["short_name"]
db_host = node["ncs_navigator"]["db"]["host"]

raise "Study center short name not configured" unless study_center_short_name
raise "Database host not configured" unless db_host

# Create warehouse databases.
db_user_password = node["ncs_navigator"]["warehouse"]["db"]["user"]["password"]
db_user = "#{node["ncs_navigator"]["warehouse"]["db"]["user_prefix"]}_#{study_center_short_name.downcase}"

ncs_navigator_db_user db_user do
  action :create
  password db_user_password
end

node["ncs_navigator"]["warehouse"]["db"]["databases"].values.each do |config|
  db_name = "#{config["name_prefix"]}_#{study_center_short_name.downcase}"

  ncs_navigator_app_db db_name do
    action :create
    password db_user_password
    username db_user
  end

  bcd_group = config["bcdatabase"]["group"]
  bcd_config = config["bcdatabase"]["config"]

  bcdatabase_config "#{bcd_group}_#{bcd_config}" do
    action :create
    adapter "postgresql"
    config bcd_config
    database db_name
    datamapper_adapter "postgres"
    group bcd_group
    host db_host
    password db_password
    username db_user
  end
end

# Build the warehouse's logging directory.
directory node["ncs_navigator"]["warehouse"]["log"]["dir"] do
  group app_group
  mode 0770
  owner user
  recursive true
end

# Deploy the base configuration file for import.
config_dir = node["ncs_navigator"]["warehouse"]["config"]["dir"]
env = node["ncs_navigator"]["env"]

directory config_dir do
  group app_group
  mode 0770
  owner user
  recursive true
end

# Create a deployment directory for the hosted data maintenance scripts.
dir_user = user
dir_group = app_group

directory node["ncs_navigator"]["hosted_data"]["dir"] do
  owner dir_user
  group dir_group
  mode 0775
  recursive true
end
