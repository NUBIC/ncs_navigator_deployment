#
# Cookbook Name:: ncs_navigator
# Recipe:: ini
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

directory ::File.dirname(node[:ncs_navigator][:ini][:path]) do
  action :create
  recursive true
end

template node[:ncs_navigator][:ini][:path] do
  sp = node[:ncs_navigator][:staff_portal]
  sc = node[:ncs_navigator][:study_center]
  sm = node[:ncs_navigator][:smtp]

  variables = {
    :cr_uri => node[:ncs_navigator][:core][:url],
    :ps_uri => node[:ncs_navigator][:psc][:url],
    :sc_footer_logo_left => sc[:footer_logo_left],
    :sc_footer_logo_right => sc[:footer_logo_right],
    :sc_footer_text => sc[:footer_text],
    :sc_id => sc[:sc_id],
    :sc_recruitment_type_id => sc[:recruitment_type_id],
    :sc_sampling_units_file => sc[:sampling_units_file],
    :sc_username => sc[:username],
    :smtp_authentication => sm[:authentication],
    :smtp_domain => sm[:domain],
    :smtp_host => sm[:host],
    :smtp_password => sm[:password],
    :smtp_port => sm[:port],
    :smtp_starttls => sm[:starttls],
    :smtp_username => sm[:username],
    :sp_email_reminder => sp[:email_reminder],
    :sp_exception_recipients => sp[:exception_recipients],
    :sp_google_analytics_number => sp[:google_analytics_number],
    :sp_mail_from => sp[:mail_from],
    :sp_psc_user_password => sp[:psc_user_password],
    :sp_uri => node[:ncs_navigator][:staff_portal][:url]
  }

  source "ncs_navigator.ini.erb"
  group group
  mode 0444
  variables variables
end
