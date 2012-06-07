#
# Cookbook Name:: logio
# Recipe:: harvester
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

include_recipe "nodejs"

require 'uri'

server_uri = URI.parse(node[:logio][:server][:uri])

# This is hardcoded by logio's start script.
harvester_user = "logio"

user harvester_user do
  action :create
  home "/home/logio"
  system true
end

bash "install log.io" do
  code <<-END
  npm install -g --prefix=#{node[:logio][:dir]} log.io
  END
end

template node[:logio][:harvester][:conf] do
  source "harvester.js.erb"
  owner harvester_user
  variables(:server_host => server_uri.host,
            :server_port => server_uri.port,
            :log_file_paths => node[:logio][:harvester][:log_file_paths],
            :instance_name => node[:fqdn])
end
