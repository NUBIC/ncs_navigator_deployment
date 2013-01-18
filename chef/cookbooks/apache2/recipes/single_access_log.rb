#
# Cookbook Name:: apache2
# Recipe:: single_access_log
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
#

conf_dir = "#{node["apache"]["dir"]}/conf.d"
access_log = node["apache"]["access_log"]

raise "Access log location undefined" if !access_log

template "#{conf_dir}/logging" do
  action :create
  source "logging.conf.erb"
  notifies :restart, resources(:service => "apache2")
  variables(:log_dir => node["apache"]["log_dir"],
            :access_log => access_log)
end
