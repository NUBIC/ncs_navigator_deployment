#
# Cookbook Name:: zeroconf
# Recipe:: cnames
#
# Copyright 2013, Northwestern University
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

include_recipe "build-essential"
include_recipe "zeroconf::devel"

cookbook_file "/tmp/publish_cnames.c" do
  source "publish_cnames.c"
end

cname_publisher_path = "/usr/local/bin/publish_cnames"
cname_publisher_dir = ::File.dirname(cname_publisher_path)
cname_publisher_pidfile = "/var/run/publish_cnames.pid"
cname_publisher_script = "#{cname_publisher_dir}/publish_cnames.sh"
hosts = node["zeroconf"]["cnames"]

bash "build publish_cnames.c" do
  code <<-END
    cd /tmp
    CONFIG=`pkg-config --cflags --libs avahi-client`
    gcc $CONFIG -Wall -o publish_cnames publish_cnames.c
    rm -f #{cname_publisher_path}
    cp publish_cnames #{cname_publisher_path}
  END
end

template cname_publisher_script do
  mode 0755
  source "publish_cnames.sh.erb"
  variables(:names => hosts,
            :publisher => cname_publisher_path,
            :pidfile => cname_publisher_pidfile)
end
