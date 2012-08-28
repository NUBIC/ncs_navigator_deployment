#
# Cookbook Name:: cas
# LWRP:: bcsec_configuration
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
  file_mode = new_resource.file_mode
  file_owner = new_resource.file_owner
  fn = new_resource.name
  fragment_dir = cas_fragment_dir(fn)

  directory fragment_dir do
    action :create
    mode 0700
    owner 'root'
    recursive true
  end

  directory ::File.dirname(fn) do
    action :create
    mode 0755
    owner file_owner
    recursive true
  end

  log "Checking for existence of #{fn}" do
    notifies :rebuild, new_resource
    not_if { ::File.exists?(fn) }
  end
end

# The rebuild action is intended to be used only by cas_* resources.  If you
# run this action from outside that context, you're on your own.
action :rebuild do
  fn = new_resource.name
  fragment_dir = cas_fragment_dir(fn)

  cookbook_file "/tmp/rebuild_cas_bcsec.rb" do
    mode 0700
  end.run_action(:create)

  execute("/tmp/rebuild_cas_bcsec.rb #{fragment_dir} #{fn}").run_action(:run)
end
