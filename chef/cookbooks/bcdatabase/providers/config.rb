## # Cookbook Name:: bcdatabase
# LWRP:: config
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

action :create do
  extend Chef::Bcdatabase::GroupHelpers

  nr = new_resource
  gn = nr.group
  cn = nr.name

  bcdatabase_group gn do
    action :create_if_missing
  end

  group_data = configs_in(gn)

  group_data[cn] = {
    'adapter' => nr.adapter,
    'host' => nr.host,
    'password' => nr.password,
    'port' => nr.port,
    'url' => nr.url,
    'username' => nr.username
  }.reject! { |_, v| v.nil? || v.empty? }

  bcdatabase_group gn do
    action :update
    
    data group_data
  end
end
