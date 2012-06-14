#
# Cookbook Name:: logstash
# Recipe:: agent
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

include_recipe "monit"
include_recipe "java"

logstash_user = node["logstash"]["agent"]["user"]
logstash_home = node["logstash"]["agent"]["home_dir"]
logstash_group = node["logstash"]["agent"]["group"]

user logstash_user do
  system true
  home logstash_home
  shell node["logstash"]["agent"]["shell"]
  supports :manage_home => true
end

group logstash_group do
  members logstash_user
end

source = node["logstash"]["agent"]["source"]["file"]
filename = URI(source).path.split('/').last
target = "#{node["logstash"]["agent"]["bin_dir"]}/#{filename}"

remote_file target do
  source source
  checksum node["logstash"]["agent"]["source"]["checksum"]
  owner logstash_user
  group logstash_group
end

logstash_config = node["logstash"]["agent"]["conf"]

directory ::File.dirname(logstash_config) do
  mode 0755
  owner logstash_user
  group logstash_group
  recursive true
end

logstash_init = node["logstash"]["agent"]["init"]
logstash_pidfile = node["logstash"]["agent"]["pid_file"]

template node["logstash"]["agent"]["init"] do
  source "logstash_init.sh.erb"
  mode 0755
  variables :pidfile => logstash_pidfile,
            :config => logstash_config,
            :user => logstash_user,
            :bin => target
end

template logstash_config do
  source "logstash_config.conf.erb"
  mode 0444
  owner logstash_user
  group logstash_group
  variables :input => node["logstash"]["agent"]["input"],
            :output => node["logstash"]["agent"]["output"]
end

monitrc "monitor_logstash", :init => logstash_init, :pidfile => logstash_pidfile

service "logstash" do
  action [:start, :enable]
end
