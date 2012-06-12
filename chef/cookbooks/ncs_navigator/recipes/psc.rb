#
# Cookbook Name:: ncs_navigator
# Recipe:: psc
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

# PSC requires larger-than-standard permgen and heaps.

include_recipe "tomcat"

ruby_block "adjust_tomcat_for_psc" do
  max_perm_size = "-XX:MaxPermSize=256M"
  max_heap_size = "-Xmx512M"

  block do
    # Strip existing -XX:MaxPermSize and -Xmx directives, and add in the
    # new ones
    cur_opts = node[:tomcat][:java_options].split(/\s+/).reject do |opt|
      opt =~ /-XX:MaxPermSize=/ || opt =~ /-Xmx/
    end

    cur_opts << max_perm_size
    cur_opts << max_heap_size

    node[:tomcat][:java_options] = cur_opts.join(' ')
    node.save unless Chef::Config[:solo]
  end

  notifies :create, resources(:template => "/etc/sysconfig/tomcat6")

  not_if do
    [max_perm_size, max_heap_size].all? { |opt| node[:tomcat][:java_options].include?(opt) }
  end
end
