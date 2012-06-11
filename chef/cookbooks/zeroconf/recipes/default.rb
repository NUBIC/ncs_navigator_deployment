#
# Cookbook Name:: zeroconf
# Recipe:: default
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

include_recipe "yumrepo::epel"

package "avahi"
package "nss-mdns"

include_recipe "iptables"

cookbook_file "/etc/nsswitch.conf" do
  source "nsswitch.conf"
  mode 0644
end

iptables_rule "zeroconf_in", :cookbook => "zeroconf"

template "/etc/avahi/avahi-daemon.conf" do
  source "avahi-daemon.conf.erb"
  mode 0444
  variables(:allowed_interfaces => node[:zeroconf][:allowed_interfaces])
end

ruby_block "rebuild iptables" do
  block { }

  notifies :run, resources(:execute => "rebuild-iptables"), :immediately
end

%w(messagebus avahi-daemon).each do |s|
  service s do
    action :start
  end

  service s do
    action :enable
  end
end
