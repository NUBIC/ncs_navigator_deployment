#
# Cookbook Name:: ncs_navigator
# Recipe:: ops_psc_ini
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

include_recipe "application_user"
include_recipe "ncs_navigator::ops"
include_recipe "ncs_navigator::psc"

psc = node["ncs_navigator"]["psc"]
smtp = node["ncs_navigator"]["smtp"]
ops = node["ncs_navigator"]["ops"]

ini_path = node["ncs_navigator"]["ini"]["path"]

ncs_navigator_ini ini_path do
  action :create
  ps_uri psc["url"]
  ps_ssl_ca_file psc["ssl"]["ca_file"]
  smtp_authentication smtp["authentication"]
  smtp_domain smtp["domain"]
  smtp_host smtp["host"]
  smtp_password smtp["password"]
  smtp_port smtp["port"]
  smtp_starttls smtp["starttls"]
  smtp_username smtp["username"]
  ops_bootstrap_user ops["bootstrap_user"]
  ops_email_reminder ops["email_reminder"]
  ops_exception_recipients ops["exception_recipients"]
  ops_google_analytics_number ops["google_analytics_number"]
  ops_mail_from ops["mail_from"]
  ops_psc_user_password ops["psc_user_password"]
  ops_uri ops["app"]["url"]
end

# Restart Ops if ncs_navigator.ini changes.
current_path = ops["app"]["current_path"]

file "#{current_path}/tmp/restart.txt" do
  action :nothing
  group node["application_user"]["group"]
  mode 0700
  owner ops["user"]["name"]

  subscribes :touch, resources(:ncs_navigator_ini => ini_path)
  only_if { ::File.exists?(current_path) }
end

# Restart PSC (well, actually, Tomcat), too.
service "restart_tomcat_on_ncs_navigator_ini_change" do
  action :nothing
  service_name "tomcat6"
  subscribes :restart, resources(:ncs_navigator_ini => ini_path)
  only_if { ::File.exists?(current_path) }
end
