#
# Cookbook Name:: cas
# Recipe:: devenv
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

include_recipe "apache2"
include_recipe "passenger::apache2-rvm"
include_recipe "java"
include_recipe "ssl_certificates"
include_recipe "tomcat"

unless node.chef_environment == "ncs_development"
  raise <<-END
  This node does not appear to be used for development, so cas::devenv cannot be used in it
  END
end

ssl_dir = ::File.dirname(node[:cas][:apache][:ssl_certificate])
cert_file = "#{ssl_dir}/cas.crt"
trust_store = node[:cas][:devenv][:trust_store][:path]
trust_store_password = node[:cas][:devenv][:trust_store][:password]
keytool = "#{node[:java][:java_home]}/bin/keytool"

ssl_certificates_development ssl_dir do
  action :install
  basename "cas"
  owner node[:apache][:user]
  group node[:apache][:group]
end

# Build a trust store for CAS...
bash "build_cas_trust_store" do
  user node[:tomcat][:user]
  group node[:tomcat][:group]
  code <<-END
  rm -f #{trust_store}
  yes | #{keytool} -import -file #{cert_file} -alias devenv -keystore #{trust_store} -storepass #{trust_store_password}
  END
end

# ...and point the Tomcat JRE at it.
java_opts = "-Djavax.net.ssl.trustStore=#{trust_store} -Djavax.net.ssl.trustStorePassword=#{trust_store_password}"

unless node[:tomcat][:java_options].include?(java_opts)
  node[:tomcat][:java_options] += " " + java_opts
  node.save unless Chef::Config[:solo]
end

ruby_block "rebuild Tomcat environment" do
  block { }

  notifies :create, resources(:template => "/etc/sysconfig/tomcat6")
  notifies :restart, resources(:service => "tomcat")
end
