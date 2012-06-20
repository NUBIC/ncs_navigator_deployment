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
include_recipe "logstash::common"

extend Chef::Logstash::Paths

logstash_role = "agent"
logstash_config = logstash_conf_path(logstash_role)
logstash_user = node["logstash"]["user"]
logstash_group = node["logstash"]["group"]

logstash_init do
  role logstash_role
end

directory ::File.dirname(logstash_config) do
  mode 0755
  owner logstash_user
  group logstash_group
  recursive true
end

template logstash_config do
  source "logstash_config.conf.erb"
  mode 0444
  owner logstash_user
  group logstash_group
  variables :input => node["logstash"]["agent"]["input"],
            :output => node["logstash"]["agent"]["output"]
end

monitrc "monitor_logstash_#{logstash_role}", :init => logstash_init_path(logstash_role),
                                             :pidfile => logstash_pid_path(logstash_role)

service logstash_service(logstash_role) do
  action [:start, :enable]
end
