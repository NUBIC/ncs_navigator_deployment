# # Cookbook Name:: ncs_navigator
# Recipe:: auth
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

# This recipe configures authentication services for the NCS Navigator
# application suite.

include_recipe "aker"

aker_central "cas" do
  action :create
  base_url node[:ncs_navigator][:cas][:base_url]
  proxy_callback_url node[:ncs_navigator][:cas][:proxy_callback_url]
  proxy_retrieval_url node[:ncs_navigator][:cas][:proxy_retrieval_url]
end
