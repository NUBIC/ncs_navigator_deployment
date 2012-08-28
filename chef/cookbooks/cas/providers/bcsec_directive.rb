#
# Cookbook Name:: cas
# LWRP:: bcsec_directive
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
  key = new_resource.key
  value = new_resource.value
  configuration = new_resource.configuration
  fragment_dir = cas_fragment_dir(configuration)

  file "#{fragment_dir}/#{key}" do
    action :create
    mode 0400
    content value
    
    notifies :rebuild, resources(:cas_bcsec_configuration => configuration)
  end
end
