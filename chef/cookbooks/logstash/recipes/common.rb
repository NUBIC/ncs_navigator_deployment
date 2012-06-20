#
# Cookbook Name:: logstash
# Recipe:: common
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

include_recipe "java"

logstash_user = node["logstash"]["user"]
logstash_home = node["logstash"]["home_dir"]
logstash_group = node["logstash"]["group"]

extend Chef::Logstash::Paths

user logstash_user do
  system true
  home logstash_home
  shell node["logstash"]["shell"]
  supports :manage_home => true
end

group logstash_group do
  members logstash_user
end

remote_file logstash_binary_path do
  source node["logstash"]["source"]["file"]
  checksum node["logstash"]["source"]["checksum"]
  owner logstash_user
  group logstash_group
end
