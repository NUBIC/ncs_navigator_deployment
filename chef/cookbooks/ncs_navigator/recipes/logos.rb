#
# Cookbook Name:: ncs_navigator
# Recipe:: logos
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

sc = node[:ncs_navigator][:study_center]

%w(footer_logo_left footer_logo_right).each do |logo|
  raise "ncs_navigator.study_center.#{logo}.path not defined" unless sc[logo][:path]

  directory ::File.dirname(sc[logo][:path]) do
    mode 0755
    recursive true
  end

  remote_file sc[logo][:path] do
    source sc[logo][:source]
    checksum sc[logo][:checksum]
    mode 0444
  end
end
