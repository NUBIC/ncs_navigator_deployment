#
# Cookbook Name:: ncs_navigator
# Recipe:: app_log_rotation
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

include_recipe "application_user"
include_recipe "logrotate"

core_user = node["ncs_navigator"]["core"]["user"]
staff_portal_user = node["ncs_navigator"]["staff_portal"]["user"]
warehouse_user = node["ncs_navigator"]["warehouse"]["user"]
app_group = node["application_user"]["group"]

core_dir = node["ncs_navigator"]["core"]["root"]
core_log_dir = "#{core_dir}/current/log"
core_old_log_dir = "#{core_dir}/old_logs"
staff_portal_dir = node["ncs_navigator"]["staff_portal"]["root"]
staff_portal_log_dir = "#{staff_portal_dir}/current/log"
staff_portal_old_log_dir = "#{staff_portal_dir}/old_logs"
warehouse_log_dir = node["ncs_navigator"]["warehouse"]["log"]["dir"]

directory core_old_log_dir do
  group app_group
  mode 0755
  owner core_user
end

directory staff_portal_old_log_dir do
  group app_group
  mode 0755
  owner staff_portal_user
end

# NCS Navigator Core.
logrotate_app "ncs_navigator_core" do
  create "644 #{core_user} #{app_group}"
  olddir core_old_log_dir
  path "#{core_log_dir}/*.log"
end

# NCS Staff Portal.
logrotate_app "ncs_staff_portal" do
  create "644 #{staff_portal_user} #{app_group}"
  olddir staff_portal_old_log_dir
  path "#{staff_portal_log_dir}/*.log"
end

# NCS MDES Warehouse.
logrotate_app "ncs_mdes_warehouse" do
  frequency "daily"
  create "644 #{warehouse_user} #{app_group}"
  path "#{warehouse_log_dir}/*.log"
end
