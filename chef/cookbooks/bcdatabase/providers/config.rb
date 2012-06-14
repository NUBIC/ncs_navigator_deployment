##
# Cookbook Name:: bcdatabase
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
  cn = nr.config

  bcdatabase_group gn do
    action :create_if_missing
  end

  configs = configs_in(gn)

  # YAML differentiates between symbols and strings, but Chef permits the use
  # of both for configuration keys.  We just want strings.
  # Also, to keep things clean, we also omit nil attributes.
  group_data = {}

  nr.attributes.each do |k, v|
    unless v.nil?
      group_data[k.to_s] = v
    end
  end

  configs[cn] = group_data

  bcdatabase_group gn do
    action :update

    data configs
  end
end
