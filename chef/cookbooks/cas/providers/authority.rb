#
# Cookbook Name:: cas
# LWRP:: authority
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

include Nubic::Cas::Directories

action :create do
  conf_file = new_resource.configuration
  authority_tag = new_resource.name
  static_file = new_resource.static_file

  authority = case new_resource.authority
              when :static then "Bcsec::Authorities::Static.from_file('#{static_file}')"
              when :netid then ':netid'
              end

  directory authorities_dir(conf_file) do
    mode 0755
    recursive true
  end

  file authority_fragment(conf_file, authority_tag) do
    action :create
    mode 0400
    content authority

    notifies :rebuild, resources(:cas_bcsec_configuration => conf_file)
    notifies :send_notification, new_resource, :immediately
  end
end

action :delete do
  authority_tag = new_resource.name
  conf_file = new_resource.configuration

  file authority_fragment(conf_file, authority_tag) do
    action :delete

    notifies :rebuild, resources(:cas_bcsec_configuration => conf_file)
    notifies :send_notification, new_resource, :immediately
  end
end

# Internal to this LWRP.
action :send_notification do
  new_resource.updated_by_last_action(true)
end

def authorities_dir(conf_file)
  cas_fragment_dir(conf_file) +  "/authorities"
end

def authority_fragment(conf_file, tag)
  "#{authorities_dir(conf_file)}/#{tag}"
end
