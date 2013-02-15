#
# Cookbook Name:: ncs_navigator
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

require 'uri'

include_recipe "apache2"
include_recipe "build-essential"
include_recipe "ssl_certificates"
include_recipe "zeroconf::devel"

unless node[:development]
  raise <<-END
  This node does not appear to be used for development, so ncs_navigator::devenv cannot be used in it
  END
end

# Install certificates for each application.
cert_path = node[:ssl_certificates][:ca_path]
key_path = node[:ssl_certificates][:key_path]
group = node[:apache][:group]
owner = node[:apache][:user]

# Self-configure.
node[:ncs_navigator][:devenv][:urls].each do |app, url|
  host = URI(url).host
  ssl_certificate = "#{cert_path}/#{host}.crt"
  ssl_key = "#{key_path}/#{host}.key"

  node[:ncs_navigator][app][:url] = url
  node[:ncs_navigator][app][:ssl] = Mash.new
  node[:ncs_navigator][app][:ssl][:certificate] = ssl_certificate
  node[:ncs_navigator][app][:ssl][:key] = ssl_key
end

node.save unless Chef::Config[:solo]

# We need to publish CNAMEs, so build a tool that will let us do that.
cookbook_file "/tmp/publish_cnames.c" do
  source "publish_cnames.c"
end

cname_publisher_path = "/usr/local/bin/publish_cnames"
cname_publisher_dir = ::File.dirname(cname_publisher_path)
cname_publisher_pidfile = "/var/run/publish_cnames.pid"
cname_publisher_script = "#{cname_publisher_dir}/publish_cnames.sh"
hosts = node[:ncs_navigator][:devenv][:urls].map { |app, url| URI(url).host }

bash "build publish_cnames.c" do
  code <<-END
    cd /tmp
    CONFIG=`pkg-config --cflags --libs avahi-client`
    gcc $CONFIG -Wall -o publish_cnames publish_cnames.c
    rm -f #{cname_publisher_path}
    cp publish_cnames #{cname_publisher_path}
  END
end

# Register the tool with Monit and run it.
monitrc "publish_cnames", :program => cname_publisher_script, :pidfile => cname_publisher_pidfile

template cname_publisher_script do
  mode 0755
  source "publish_cnames.sh.erb"
  variables(:names => hosts,
            :publisher => cname_publisher_path,
            :pidfile => cname_publisher_pidfile)

  notifies :restart, "service[monit]", :immediately
end

node[:ncs_navigator][:devenv][:urls].each do |app, url|
  ssl_certificate = node[:ncs_navigator][app][:ssl][:certificate]
  ssl_key = node[:ncs_navigator][app][:ssl][:key]

  cookbook_file ssl_certificate do
    cookbook "ssl_certificates"
    group group
    owner owner
    mode 0444
    source "wildcard.local.crt"
  end

  cookbook_file ssl_key do
    cookbook "ssl_certificates"
    group group
    owner owner
    mode 0400
    source "wildcard.local.key"
  end
end

java_keystore "add_devenv_certificates_to_psc" do
  action :import
  keystore node["tomcat"]["keystore"]["path"]
  storepass node["tomcat"]["keystore"]["password"]
  cert_file node[:ncs_navigator][:psc][:ssl][:certificate]
  cert_alias "devenv"
end
