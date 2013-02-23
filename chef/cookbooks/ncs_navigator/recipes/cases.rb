#
# Cookbook Name:: ncs_navigator
# Recipe:: cases
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
include_recipe "monit"
include_recipe "passenger"
include_recipe "ssl_certificates"

ncs_rails_app "cases"

study_center_short_name = node["ncs_navigator"]["cases"]["study_center"]["short_name"]
raise "Study center short name not configured" unless study_center_short_name

# Database and corresponding user.
db_name = "#{node["ncs_navigator"]["cases"]["db"]["name_prefix"]}_#{study_center_short_name.downcase}"
db_user_name = "#{node["ncs_navigator"]["cases"]["db"]["user_prefix"]}_#{study_center_short_name.downcase}"
db_user_password = node["ncs_navigator"]["cases"]["db"]["user"]["password"]

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
ncs_navigator_bcdatabase_config 'cases' do
  config_hash node["ncs_navigator"]["cases"]["db"]["bcdatabase"]
  database db_name
  password db_user_password
  pool_size node["ncs_navigator"]["cases"]["db"]["pool"]
  username db_user_name
end

# Redis configuration.
redis = node["ncs_navigator"]["cases"]["redis"]

bcdatabase_config "redis_for_cases" do
  action :create
  config redis["bcdatabase"]["config"]
  group redis["bcdatabase"]["group"]
  host redis["host"]
  port redis["port"]
  db redis["db"]
end

# Sampling units file.
ssu_databag = node["ncs_navigator"]["cases"]["study_center"]["sampling_units"]["data_bag"]
ssu_tsu_src = node["ncs_navigator"]["cases"]["study_center"]["sampling_units"]["data_bag_item"]
ssu_tsu_dst = node["ncs_navigator"]["cases"]["study_center"]["sampling_units"]["target"]
raise "Sampling units databag item not defined" unless ssu_tsu_src
raise "Sampling units target not defined" unless ssu_tsu_dst

ssu_data = data_bag_item(ssu_databag, ssu_tsu_src)
raise "Unable to find SSU data for #{ssu_src} in #{ssu_databag} data bag" unless ssu_data

app_group = node["application_user"]["group"]

directory File.dirname(ssu_tsu_dst) do
  recursive true
  group app_group
end

file ssu_tsu_dst do
  mode 0444
  group app_group
  content ssu_data['data']
end

# Application logos.
sc = node["ncs_navigator"]["cases"]["study_center"]

%w(footer_logo_left footer_logo_right).each do |logo|
  unless sc[logo]["path"]
    raise "ncs_navigator/cases/study_center/#{logo}/path not defined"
  end

  directory File.dirname(sc[logo]["path"]) do
    mode 0755
    recursive true
  end

  remote_file sc[logo]["path"] do
    source sc[logo]["source"]
    checksum sc[logo]["checksum"]
    mode 0444
  end
end

# Monitoring.
monitrc "monitor_cases_sidekiq",
  :pid => node["ncs_navigator"]["cases"]["worker"]["pid"],
  :log => node["ncs_navigator"]["cases"]["worker"]["log"],
  :concurrency => node["ncs_navigator"]["cases"]["worker"]["concurrency"],
  :env => node["ncs_navigator"]["env"],
  :current_path => node["ncs_navigator"]["cases"]["app"]["current_path"],
  :uid => node["ncs_navigator"]["cases"]["user"]["name"],
  :gid => node["application_user"]["group"]

monitrc "monitor_cases_scheduler",
  :pid => node["ncs_navigator"]["cases"]["scheduler"]["pid"],
  :log => node["ncs_navigator"]["cases"]["scheduler"]["log"],
  :env => node["ncs_navigator"]["env"],
  :current_path => node["ncs_navigator"]["cases"]["app"]["current_path"],
  :uid => node["ncs_navigator"]["cases"]["user"]["name"],
  :gid => node["application_user"]["group"]

monitrc "monitor_cases_redis",
  :host => node["ncs_navigator"]["cases"]["redis"]["host"],
  :port => node["ncs_navigator"]["cases"]["redis"]["port"]
