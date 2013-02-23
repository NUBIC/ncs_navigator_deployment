#
# Cookbook Name:: ncs_navigator
# Provider:: app_user
#
# Copyright 2013, Northwestern University
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
  extend Chef::ApplicationUser::Home

  user = new_resource.name
  groups = new_resource.groups
  keys = new_resource.keys

  application_user user do
    action :create
    groups groups
    authorized_keys keys
  end

  user_home = application_user_home(user)

  # Configure the user's environment for running the app.
  template "#{user_home}/.bashrc" do
    source "bashrc.erb"
    mode 0444
    variables(:ruby => node["passenger"]["rvm_ruby_string"])
    only_if { ::File.exists?(user_home) }
  end
end
