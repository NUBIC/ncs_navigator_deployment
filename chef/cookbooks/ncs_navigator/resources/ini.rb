#
# Cookbook Name:: ncs_navigator
# Resource:: ini
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

# The send_notification action is internal to this LWRP.
actions :create, :send_notification

attribute :cr_machine_account_password, :kind_of => String
attribute :cr_machine_account_username, :kind_of => String
attribute :cr_mail_from, :kind_of => String
attribute :cr_sync_log_level, :kind_of => String
attribute :cr_uri, :kind_of => String
attribute :cr_with_specimens, :kind_of => String
attribute :ops_bootstrap_user, :kind_of => String
attribute :ops_email_reminder, :kind_of => String
attribute :ops_exception_recipients, :kind_of => Array
attribute :ops_google_analytics_number, :kind_of => String
attribute :ops_mail_from, :kind_of => String
attribute :ops_psc_user_password, :kind_of => String
attribute :ops_uri, :kind_of => String
attribute :ps_ssl_ca_file, :kind_of => String
attribute :ps_uri, :kind_of => String
attribute :sc_exception_email_recipients, :kind_of => Array
attribute :sc_footer_logo_left, :kind_of => String
attribute :sc_footer_logo_right, :kind_of => String
attribute :sc_footer_text, :kind_of => String
attribute :sc_id, :kind_of => String
attribute :sc_recruitment_type_id, :kind_of => String
attribute :sc_sampling_units_file, :kind_of => String
attribute :sc_short_name, :kind_of => String
attribute :sc_username, :kind_of => String
attribute :smtp_authentication, :kind_of => String
attribute :smtp_domain, :kind_of => String
attribute :smtp_host, :kind_of => String
attribute :smtp_password, :kind_of => String
attribute :smtp_port, :kind_of => String
attribute :smtp_starttls, :kind_of => String
attribute :smtp_username, :kind_of => String
