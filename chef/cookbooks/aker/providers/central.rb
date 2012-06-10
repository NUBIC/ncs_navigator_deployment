#
# Cookbook Name:: aker
# LWRP:: central
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

require 'json'

action :create do
  section = new_resource.name
  path = node[:aker][:central][:path]

  node[:aker][:central][:config][section] = new_resource.attributes
  node.save unless Chef::Config[:solo]

  data = {}

  node[:aker][:central][:config].keys.each do |k|
    data[k] = node[:aker][:central][:config][k].current_normal.to_hash
  end

  group node[:aker][:central][:group] do
    action :create
  end

  directory ::File.dirname(node[:aker][:central][:path]) do
    mode 0755
    group node[:aker][:central][:group]
    recursive true
  end

  file node[:aker][:central][:path] do
    mode 0440
    group node[:aker][:central][:group]
    content data.to_yaml
  end
end
