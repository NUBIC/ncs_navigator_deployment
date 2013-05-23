#
# Cookbook Name:: ncs_navigator
# Recipe:: pancakes_devenv
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

unless node[:development]
  raise "pancakes_devenv cannot be used in a non-development node"
end

# Install SSL certificate and key material.
ssl_certificate = node["ncs_navigator"]["pancakes"]["ssl"]["certificate"]
ssl_key = node["ncs_navigator"]["pancakes"]["ssl"]["key"]
group = node["apache"]["group"]
owner = node["apache"]["owner"]

cookbook_file ssl_certificate do
  cookbook "ssl_certificates"
  group group
  owner owner
  mode 0444
  source "wildcard.local.crt"
end

cookbook_file ssl_key do
  cookbook "ssl_certificates"
  group group
  owner owner
  mode 0400
  source "wildcard.local.key"
end
