#
# Cookbook Name:: cas
# Recipe:: static_auth
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

include_recipe "tomcat"

cas_owner = node["tomcat"]["user"]

# Do we have a desired static authority configuration? If so, load it in.
config = node["cas"]["static_authority"]["config"]
path = node["cas"]["static_authority"]["path"]

if config
  file path do
    mode 0400
    owner cas_owner
    content config
  end

  cas_authority "cas_static_authority" do
    action :create
    authority :static
    configuration node[:cas][:bcsec]
    static_file path

    notifies :restart, :service => 'tomcat'
  end
end
