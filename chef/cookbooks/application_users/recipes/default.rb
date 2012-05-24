#
# Cookbook Name:: application_users
# Recipe:: default
#
# Copyright 2011, NUBIC
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

group_name = node[:application_users][:group]
shell = node[:application_users][:shell]
ssh_key_databag = node[:application_users][:ssh_key_databag]
users = node[:application_users][:users]

include_recipe "selinux"

# Cache SSH keys.
# Chef makes an API call for each `data_bag_item` invocation, so it's a good
# idea to minimize data bag interactions.  For now, just pulling back every SSH
# key is fine.
ssh_keys = {}

search(ssh_key_databag, "*:*").each do |entry|
  ssh_keys[entry["id"]] = entry["key"]
end

users.each do |username, config|
  home_dir = "/home/#{username}"
  groups = config['groups'] || []

  user username do
    comment "Application user"
    home home_dir
    shell shell
    supports :manage_home => true
    system true
  end

  # ...and load their key set.
  keys = config["authorized_keys"].map { |key_name| ssh_keys[key_name] }
  ssh_dir = "#{home_dir}/.ssh"

  directory ssh_dir do
    owner username
  end

  template "#{ssh_dir}/authorized_keys" do
    mode 0400
    owner username
    source "authorized_keys.erb"
    variables :keys => keys
  end

  # The SSH directory needs to have the ssh_home_t security context; otherwise,
  # sshd won't be able to read it.  The default security context for ~/.ssh
  # needs to be restored after we muck with it.
  selinux_security_context ssh_dir do
    action :restore
  end

  # Add the user to the specified groups.
  groups.each do |g|
    group g do
      append true
      members username
    end
  end
end

# Converge the application group.
group group_name do
  members users.keys
end
