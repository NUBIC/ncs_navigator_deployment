#
# Cookbook Name:: cas
# Recipe:: monitoring
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

include_recipe "monit"
include_recipe "logio"

# Hardcoded by /etc/sysconfig/tomcat6.
tomcat_pid = "/var/run/tomcat6.pid"

tomcat_port = node[:tomcat][:ajp_port]
apache_pid = node[:apache][:pid_file]
cas_path = "/#{node[:cas][:script_name]}/login"
callback_path = "/#{node[:cas][:callback][:script_name]}/receive_pgt"
host = "localhost"

# Is the Tomcat process up? If not, restart Tomcat.
monitrc "cas_via_tomcat", :pid => tomcat_pid, :host => host, :port => tomcat_port

# Is the Apache process up? If not, restart Apache.
monitrc "cas_via_apache", :pid => apache_pid, :host => host, :port => 443, :cas_path => cas_path

# Can we access the proxy callbacks?  If not, restart Apache.
monitrc "cas_proxy_callbacks", :pid => apache_pid, :host => host, :port => 443, :callback_path => callback_path

# Harvest the CAS server log.
logio_harvester_path "nubic-cas" do
  action :add
  path node[:cas][:log]
end
