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

require 'uri'

include_recipe "monit"

# Hardcoded by /etc/sysconfig/tomcat6.
tomcat_pid = "/var/run/tomcat6.pid"

tomcat_port = node[:tomcat][:ajp_port]
apache_pid = node[:apache][:pid_file]
cas_uri = URI(node[:cas][:base_url])
proxy_callback_uri = URI(node[:cas][:proxy_callback_url])
proxy_retrieval_uri = URI(node[:cas][:proxy_retrieval_url])

# Is the Tomcat process up? If not, restart Tomcat.
monitrc "cas_via_tomcat", :pid => tomcat_pid, :host => 'localhost', :port => tomcat_port

# Is Apache up? If not, restart Apache.
monitrc "apache", :pid => apache_pid

# Can we get to CAS via Apache?
monitrc "cas_via_apache", :host => cas_uri.host, :port => cas_uri.port, :cas_path => "#{cas_uri.path}/login"

# Can we access the proxy callbacks?
monitrc "cas_proxy_callbacks", :proxy_callback_uri => proxy_callback_uri, :proxy_retrieval_uri => proxy_retrieval_uri
