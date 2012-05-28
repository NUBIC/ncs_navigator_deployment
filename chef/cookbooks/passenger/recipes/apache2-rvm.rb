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

passenger_ruby = "#{node[:rvm][:root_path]}/rubies/#{rvm_ruby_string}/bin/ruby"
passenger_root = "#{node[:rvm][:root_path]}/gems/#{rvm_ruby_string}/gems/passenger-#{node[:passenger][:version]}"
module_path = "#{passenger_root}/ext/apache2/mod_passenger.so"

%w(httpd-devel curl-devel apr-devel apr-util-devel).each do |pkg|
  package pkg
end

gem_package "passenger" do
  gem_binary rvm_gem_binary
  version node[:passenger][:version]
end

# On first run, the attributes referenced by the following resources won't
# exist until the "set Passenger attributes" Ruby block completes.  Therefore,
# these resources are set to action :nothing so that they do nothing in their
# implicit positions.
execute "install_passenger_module" do
  command "#{rvm_exec} passenger-install-apache2-module --auto"
  creates module_path
end

template passenger_load do
  source "passenger.load.erb"
  owner node[:apache][:user]
  group node[:apache][:group]
  variables(:module_path => module_path)
end

template passenger_conf do
  source "passenger.conf.erb"
  owner node[:apache][:user]
  group node[:apache][:group]
  variables(:passenger_root => passenger_root,
            :passenger_ruby => passenger_ruby)
end

# The apache_module definition in the apache2 cookbook will overwrite our
# Passenger configuration, so we'll just symlink everything ourselves.
link "#{node[:apache][:dir]}/mods-enabled/passenger.load" do
  to passenger_load
end

link "#{node[:apache][:dir]}/mods-enabled/passenger.conf" do
  to passenger_conf
end
