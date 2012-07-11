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

include_recipe "passenger"
include_recipe "rvm"

app_ruby = node["passenger"]["rvm_ruby_string"]

node["ncs_navigator"]["diagnostic_users"].each do |username|
  rvm_default_ruby app_ruby do
    user username
  end
end
