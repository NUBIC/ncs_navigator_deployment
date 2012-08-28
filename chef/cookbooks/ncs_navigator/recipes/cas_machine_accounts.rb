#
# Cookbook Name:: ncs_navigator
# Recipe:: cas_machine_accounts
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

include_recipe "cas::server"
include_recipe "tomcat"

account_file = node["ncs_navigator"]["machine_accounts"]["file"]

# The CAS server needs to be able to read the machine account file.
file account_file do
  mode 0400
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
end

# Augments the CAS configuration with a static authority for machine accounts.
cas_authority "ncs_machine_accounts" do
  action :create
  authority :static
  configuration node["cas"]["bcsec"]
  static_file node["ncs_navigator"]["machine_accounts"]["file"]

  notifies :restart, :service => 'tomcat'
end
