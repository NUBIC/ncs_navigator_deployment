#
# Cookbook Name:: selinux
# Recipe:: management
#
# Copyright 2011, NUBIC
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

# Install packages needed for SELinux policy management.

packages = case node[:platform]
           when "redhat", "centos" then %w(policycoreutils)
           else raise "selinux::management has no packages defined for #{node[:platform]}"
           end

packages.each { |p| package(p) }
