#
# Cookbook Name:: ncs_navigator
# Recipe:: sampling_units
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

app_group = node[:application_user][:group]
ssu_src = node[:ncs_navigator][:study_center][:sampling_units][:data_bag_item]
ssu_dst = node[:ncs_navigator][:study_center][:sampling_units][:target]

ssu_data = data_bag_item("ncs_ssus", ssu_src)

raise "Unable to find SSU data for #{ssu_src} in ncs_ssus data bag" unless ssu_data

directory ::File.dirname(ssu_dst) do
  recursive true
  group app_group
end

file ssu_dst do
  mode 0444
  group app_group
  content ssu_data['data']
end

