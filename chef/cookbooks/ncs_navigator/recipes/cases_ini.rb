#
# Cookbook Name:: ncs_navigator
# Recipe:: cases_ini
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
include_recipe "ncs_navigator::cases"

cases = node["ncs_navigator"]["cases"]
ops = node["ncs_navigator"]["ops"]
psc = node["ncs_navigator"]["psc"]
smtp = node["ncs_navigator"]["smtp"]
study_center = node["ncs_navigator"]["cases"]["study_center"]

ini_path = node["ncs_navigator"]["ini"]["path"]

ncs_navigator_ini ini_path do
  action :create
  cr_mail_from cases["mail_from"]
  cr_sync_log_level cases["sync_log_level"]
  cr_uri cases["app"]["url"]
  cr_with_specimens cases["with_specimens"]
  cr_machine_account_username cases["machine_account"]["username"]
  cr_machine_account_password cases["machine_account"]["password"]
  ps_uri psc["url"]
  sc_exception_email_recipients study_center["exception_email_recipients"]
  sc_footer_logo_left study_center["footer_logo_left"]["path"]
  sc_footer_logo_right study_center["footer_logo_right"]["path"]
  sc_footer_text study_center["footer_text"]
  sc_id study_center["sc_id"]
  sc_recruitment_type_id study_center["recruitment_type_id"]
  sc_sampling_units_file (su = study_center["sampling_units"]) ? su["target"] : nil
  sc_short_name study_center["short_name"]
  sc_username study_center["username"]
  ops_uri ops["app"]["url"]
  smtp_authentication smtp["authentication"]
  smtp_domain smtp["domain"]
  smtp_host smtp["host"]
  smtp_password smtp["password"]
  smtp_port smtp["port"]
  smtp_starttls smtp["starttls"]
  smtp_username smtp["username"]
end

# Restart Cases if ncs_navigator.ini changes.
current_path = cases["app"]["current_path"]

file "#{current_path}/tmp/restart.txt" do
  action :nothing
  group node["application_user"]["group"]
  mode 0700
  owner cases["user"]["name"]

  subscribes :touch, resources(:ncs_navigator_ini => ini_path)
  only_if { ::File.exists?(current_path) }
end
