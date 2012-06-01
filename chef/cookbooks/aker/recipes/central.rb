#
# Cookbook Name:: aker
# Recipe:: central
#
# Copyright 2011, Northwestern University
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

template node[:aker][:central][:path] do
  source "bcsec.yml.erb"
  mode 0440
  group node[:aker][:central][:group]

  variables(:pers_group => node[:aker][:central][:pers][:group],
            :pers_entry => node[:aker][:central][:pers][:entry],
            :netid_user => node[:aker][:central][:netid][:user],
            :netid_password => node[:aker][:central][:netid][:password],
            :cas_base_url => node[:aker][:central][:cas][:base_url],
            :cas_proxy_retrieval_url => node[:aker][:central][:cas][:proxy_retrieval_url],
            :cas_proxy_callback_url => node[:aker][:central][:cas][:proxy_callback_url]
           )
end
