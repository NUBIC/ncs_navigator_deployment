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

group = node["application_user"]["group"]
core_log_dir = "#{node["ncs_navigator"]["core"]["root"]}/current/log"
staff_portal_log_dir = "#{node["ncs_navigator"]["staff_portal"]["root"]}/current/log"

# NCS Navigator Core.
logrotate_app "ncs_navigator_core" do
  create "444 #{node["ncs_navigator"]["core"]["user"]} #{group}"
  rotate 0
  olddir "#{core_log_dir}/old"
  path "#{core_log_dir}/*.log"
end

# NCS Staff Portal.
logrotate_app "ncs_staff_portal" do
  create "444 #{node["ncs_navigator"]["staff_portal"]["user"]} #{group}"
  rotate 0
  olddir "#{staff_portal_log_dir}/old"
  path "#{staff_portal_log_dir}/*.log"
end

# NCS MDES Warehouse.
logrotate_app "ncs_mdes_warehouse" do
  frequency "daily"
  rotate 0
  path "#{node["ncs_navigator"]["warehouse"]["log"]["dir"]}/*.log"
end
