#
# Cookbook Name:: ncs_navigator
# Recipe:: machine_accounts
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
require 'yaml'

accounts = node["ncs_navigator"]["machine_accounts"]

directory ::File.dirname(accounts["file"]) do
  mode 0755
  recursive true
end

# We don't want Mash type tags showing up in our Aker configuration file, as
# applications loading said file will have no idea what a Mash is.  This is an
# extremely cheesy yet effective way to get down to YAML maps and lists and
# force all keys to a single type.
#
# If there's a recursive variant of Mash#to_hash, I'd love to know about it.
account_data = JSON.parse(accounts['data'].to_hash.to_json).to_yaml

# This mode is intentional: account data should only be exposed to processes
# that need to know it.
#
# See cas::server and ncs_navigator::app for examples of recipes that modify
# permissions.
file accounts["file"] do
  mode 0400
  content account_data
end
