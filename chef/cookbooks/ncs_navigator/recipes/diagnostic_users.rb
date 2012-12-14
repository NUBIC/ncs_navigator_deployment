#
# Cookbook Name:: ncs_navigator
# Recipe:: diagnostic_users
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

include_recipe "rvm"

app_ruby = node["ncs_navigator"]["rvm"]["ruby"]

node["ncs_navigator"]["diagnostic_users"].each do |username|
  template "/home/#{username}/.bashrc" do
    mode 0644
    owner username
    source "bashrc.erb"
    variables(:ruby => app_ruby)
  end
end
