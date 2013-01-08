#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

include_recipe "java"

tomcat_pkgs = ["tomcat6"]

tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service "tomcat" do
  service_name "tomcat6"
  case node["platform"]
  when "centos","redhat","fedora"
    supports :restart => true, :status => true
  when "debian","ubuntu"
    supports :restart => true, :reload => true, :status => true
  end
  action [:enable, :start]
end

case node["platform"]
when "centos","redhat","fedora"
  template "/etc/sysconfig/tomcat6" do
    source "sysconfig_tomcat6.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, resources(:service => "tomcat")
  end
else
  template "/etc/default/tomcat6" do
    source "default_tomcat6.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, resources(:service => "tomcat")
  end
end

template "/etc/tomcat6/server.xml" do
  source "server.xml.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "tomcat")
end

# Receives rebuild notifications, triggers Tomcat restart if run.
properties_defs = node["tomcat"]["catalina_properties"]["defs"]
properties_file = node["tomcat"]["catalina_properties"]["file"]

ruby_block "rebuild_tomcat_properties" do
  action :nothing

  block do
    Chef::Log.info "Rebuilding #{properties_file}"

    content = Dir["#{properties_defs}/*"].sort.map { |t| File.read(t) }.join("\n")
    File.open(properties_file, 'w') { |f| f.write(content) }
  end

  notifies :restart, resources(:service => 'tomcat')
end

# The properties file must be a concatenation of each component: nothing more,
# nothing less.  If that assertion is false, the properties file is rebuilt.
ruby_block "verify_property_inclusion" do
  block do
    actual = File.read(properties_file)
    expected = Dir["#{properties_defs}/*"].sort.map { |t| File.read(t) }.join("\n")

    if actual != expected
      resources(:ruby_block => "rebuild_tomcat_properties").run_action(:create)

      # Annoyingly, the above doesn't trigger notifications under Chef 0.10.6.
      resources(:service => 'tomcat').run_action(:restart)
    else
      Chef::Log.info "#{properties_file} intact, not rebuilding"
    end
  end

  only_if { File.exists?(properties_file) }
end

# Set default Tomcat properties
tomcat_properties "default_tomcat_properties" do
  source "default_tomcat_properties.erb"
end

# node["tomcat"]["custom_properties"] is deprecated, so remove it if it exists.
node["tomcat"].delete "custom_properties"
