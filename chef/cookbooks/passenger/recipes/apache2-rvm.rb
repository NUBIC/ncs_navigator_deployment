#
# Cookbook Name:: passenger
# Recipe:: apache2-rvm
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

rvm_ruby_string = "#{node[:passenger][:rvm_ruby_string]}"
rvm_exec = "#{node[:rvm][:root_path]}/bin/rvm #{rvm_ruby_string} exec"
rvm_gem_binary = "#{rvm_exec} gem"

passenger_load = "#{node[:apache][:dir]}/mods-available/passenger.load"
passenger_conf = "#{node[:apache][:dir]}/mods-available/passenger.conf"

gem_package "passenger" do
  gem_binary rvm_gem_binary
end

ruby_block "set Passenger attributes" do
  block do
    passenger_root = `#{rvm_exec} passenger-config --root`.chomp
    passenger_ruby = `#{rvm_exec} which ruby`.chomp

    node.set[:passenger][:module_path] = "#{passenger_root}/ext/apache2/mod_passenger.so"
    node.set[:passenger][:passenger_root] = passenger_root
    node.set[:passenger][:passenger_ruby] = passenger_ruby
  end

  notifies :run, "execute[install_passenger_module]", :immediately
  notifies :create, "template[#{passenger_load}]", :immediately
  notifies :create, "template[#{passenger_conf}]", :immediately
  notifies :restart, "service[apache2]"
end

# On first run, the attributes referenced by the following resources won't
# exist until the "set Passenger attributes" Ruby block completes.  Therefore,
# these resources are set to action :nothing so that they do nothing in their
# implicit positions.
template passenger_load do
  source "passenger.load.erb"
  variables(:module_path    => node[:passenger][:module_path],
            :passenger_root => node[:passenger][:passenger_root],
            :passenger_ruby => node[:passenger][:passenger_ruby])

  owner node[:apache][:user]
  group node[:apache][:group]
  action :nothing
end

template passenger_conf do
  source "passenger.conf.erb"
  variables(:passenger_root => node[:passenger][:passenger_root],
            :passenger_ruby => node[:passenger][:passenger_ruby])

  owner node[:apache][:user]
  group node[:apache][:group]
  action :nothing
end

execute "install_passenger_module" do
  command "#{rvm_exec} passenger-install-apache2-module --auto"
  creates node[:passenger][:module_path] 
  action :nothing
end

# The apache_module definition in the apache2 cookbook will overwrite our
# Passenger configuration, so we'll just symlink everything ourselves.
link "#{node[:apache][:dir]}/mods-enabled/passenger.load" do
  to passenger_load
end

link "#{node[:apache][:dir]}/mods-enabled/passenger.conf" do
  to passenger_conf
end
