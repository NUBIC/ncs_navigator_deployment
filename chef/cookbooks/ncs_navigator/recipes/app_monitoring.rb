#
# Cookbook Name:: ncs_navigator
# Recipe:: app_monitoring
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

require 'uri'

include_recipe "apache2"
include_recipe "application_user"
include_recipe "monit"
include_recipe "tomcat"

monitrc "monitor_cases_sidekiq",
  :pid => node[:ncs_navigator][:core][:worker][:pid],
  :log => node[:ncs_navigator][:core][:worker][:log],
  :concurrency => node[:ncs_navigator][:core][:worker][:concurrency],
  :env => node[:ncs_navigator][:env],
  :current_path => node[:ncs_navigator][:core][:current_path],
  :uid => node[:ncs_navigator][:core][:user],
  :gid => node[:application_user][:group]

monitrc "monitor_cases_scheduler",
  :pid => node[:ncs_navigator][:core][:scheduler][:pid],
  :log => node[:ncs_navigator][:core][:scheduler][:log],
  :env => node[:ncs_navigator][:env],
  :current_path => node[:ncs_navigator][:core][:current_path],
  :uid => node[:ncs_navigator][:core][:user],
  :gid => node[:application_user][:group]

monitrc "monitor_apache2", :pid => node[:apache][:pid_file]
monitrc "monitor_tomcat", :pid => "/var/run/tomcat6.pid"
monitrc "monitor_ncs_navigator"
