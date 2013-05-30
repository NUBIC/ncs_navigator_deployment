#
# Cookbook Name:: ncs_navigator
# Provider:: ini
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

action :create do
  ini_path = new_resource.name

  directory ::File.dirname(ini_path) do
    action :create
    recursive true
  end

  app_group = node["application_user"]["group"]

  template ini_path do
    action :create
    group app_group
    mode 0444
    source "ncs_navigator.ini.erb"
    variables vars(new_resource)
    notifies :send_notification, new_resource, :immediately
  end
end

# Internal to this LWRP.
action :send_notification do
  new_resource.updated_by_last_action(true)
end

def vars(new_resource)
  %w(
    cr_machine_account_password
    cr_machine_account_username
    cr_mail_from
    cr_sync_log_level
    cr_uri
    cr_with_specimens
    ops_bootstrap_user
    ops_email_reminder
    ops_exception_recipients
    ops_google_analytics_number
    ops_mail_from
    ops_psc_user_password
    ops_uri
    pancakes_mdes_version
    ps_ssl_ca_file
    ps_uri
    sc_exception_email_recipients
    sc_footer_logo_left
    sc_footer_logo_right
    sc_footer_text
    sc_id
    sc_recruitment_type_id
    sc_sampling_units_file
    sc_short_name
    sc_username
    smtp_authentication
    smtp_domain
    smtp_host
    smtp_password
    smtp_port
    smtp_starttls
    smtp_username
  ).inject({}) do |h, k|
    h.update(k => new_resource.send(k))
  end
end
