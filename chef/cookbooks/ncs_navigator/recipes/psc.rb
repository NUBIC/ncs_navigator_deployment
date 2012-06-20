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
include_recipe "application_user"

extend Chef::ApplicationUser::Home

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

# OSGi bundles need this.
#
# See https://code.bioinformatics.northwestern.edu/issues/wiki/psc/Deploying_plugins.
psc_user = node["ncs_navigator"]["psc"]["user"]
psc_bundle_dir = "#{application_user_home(psc_user)}/psc"

%w(configurations libraries plugins).each do |dir|
  directory "#{psc_bundle_dir}/bundles/#{dir}" do
    recursive true
    owner psc_user
    owner node["ncs_navigator"]["psc"]["user"]
    group node["tomcat"]["group"]
    mode 0775
  end
end

# To avoid dumping large JARs under /etc/tomcat6 (which is the target of
# /usr/share/tomcat6/conf), we symlink /usr/share/tomcat6/conf/psc to
# psc_bundle_dir.
link "#{node["tomcat"]["base"]}/conf/psc" do
  to psc_bundle_dir
end
