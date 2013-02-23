#
# Cookbook Name:: ncs_navigator
# Recipe:: https_redirect
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

include_recipe "apache2"

# Rewrite HTTP URLs as HTTPS URLs.
# The default site defines rules for VirtualHost *:80, so make sure that's off
# too.
template "#{node[:apache][:dir]}/sites-available/https_redirect" do
  source "https_redirect.erb"
end

apache_module "rewrite"
apache_site "https_redirect"
apache_site "default" do
  enable false
end
