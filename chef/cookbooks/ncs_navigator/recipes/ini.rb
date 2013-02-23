#
# Cookbook Name:: ncs_navigator
# Recipe:: ini
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

ini_path = node["ncs_navigator"]["ini"]["path"]

directory File.dirname(ini_path) do
  action :create
  recursive true
end

app_group = node["application_user"]["group"]
sp = node["ncs_navigator"]["staff_portal"]
sc = node["ncs_navigator"]["cases"]["study_center"]
sm = node["ncs_navigator"]["smtp"]

template ini_path do
  group app_group
  mode 0444
  source "ncs_navigator.ini.erb"
  variables(
    :cr_mail_from => node["ncs_navigator"]["cases"]["mail_from"],
    :cr_sync_log_level => node["ncs_navigator"]["cases"]["sync_log_level"],
    :cr_uri => node["ncs_navigator"]["cases"]["app"]["url"],
    :cr_with_specimens => node["ncs_navigator"]["cases"]["with_specimens"],
    :cr_machine_account_username => node["ncs_navigator"]["cases"]["machine_account"]["username"],
    :cr_machine_account_password => node["ncs_navigator"]["cases"]["machine_account"]["password"],
    :ps_uri => node["ncs_navigator"]["psc"]["url"],
    :ps_ssl_ca_file => node["ncs_navigator"]["psc"]["ssl"]["ca_file"],
    :sc_footer_logo_left => sc["footer_logo_left"]["path"],
    :sc_footer_logo_right => sc["footer_logo_right"]["path"],
    :sc_footer_text => sc["footer_text"],
    :sc_id => sc["sc_id"],
    :sc_recruitment_type_id => sc["recruitment_type_id"],
    :sc_sampling_units_file => sc["sampling_units"] ? sc["sampling_units"]["target"] : nil,
    :sc_username => sc["username"],
    :sc_short_name => sc["short_name"],
    :sc_exception_email_recipients => sc["exception_email_recipients"],
    :smtp_authentication => sm["authentication"],
    :smtp_domain => sm["domain"],
    :smtp_host => sm["host"],
    :smtp_password => sm["password"],
    :smtp_port => sm["port"],
    :smtp_starttls => sm["starttls"],
    :smtp_username => sm["username"],
    :sp_bootstrap_user => sp["bootstrap_user"],
    :sp_email_reminder => sp["email_reminder"],
    :sp_exception_recipients => sp["exception_recipients"],
    :sp_google_analytics_number => sp["google_analytics_number"],
    :sp_mail_from => sp["mail_from"],
    :sp_psc_user_password => sp["psc_user_password"],
    :sp_uri => node["ncs_navigator"]["staff_portal"]["url"]
  )
end
