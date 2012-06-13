#
# Cookbook Name:: postgresql
# Recipe:: server
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Lamont Granquist (<lamont@opscode.com>)
# Copyright 2009-2011, Opscode, Inc.
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

case node['platform']
when "redhat","centos","scientific","fedora"
  include_recipe "yumrepo::postgresql9"
end

include_recipe "postgresql::client"

version = node['postgresql']['version']

# randomly generate postgres password
node.set_unless[:postgresql][:password][:postgres] = secure_password

# The PostgreSQL directory depends on the version, so set it once said version
# is known to exist.
node[:postgresql][:dir] = "/var/lib/pgsql/#{version}/data"

node.save unless Chef::Config[:solo]

case version
when "8.3"
  node.default[:postgresql][:ssl] = "off"
when "8.4"
  node.default[:postgresql][:ssl] = "true"
end

# Include the right "family" recipe for installing the server
# since they do things slightly differently.
case node.platform
when "redhat", "centos", "fedora", "suse", "scientific", "amazon"
  include_recipe "postgresql::server_redhat"
when "debian", "ubuntu"
  include_recipe "postgresql::server_debian"
end

template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  variables :hba => node[:postgresql][:hba]
  notifies :reload, resources(:service => "postgresql-#{version}"), :immediately
end

# Default PostgreSQL install has 'ident' checking on unix user 'postgres'
# and 'md5' password checking with connections from 'localhost'. This script
# runs as user 'postgres', so we can execute the 'role' and 'database' resources
# as 'root' later on, passing the below credentials in the PG client.
bash "assign-postgres-password" do
  user 'postgres'
  code <<-EOH
echo "ALTER ROLE postgres ENCRYPTED PASSWORD '#{node[:postgresql][:password][:postgres]}';" | psql
  EOH

  not_if <<-END
    umask 077
    PGPASSFILE=/tmp/pgpass.$$
    echo "localhost:5432:postgres:postgres:#{node[:postgresql][:password][:postgres]}" > $PGPASSFILE
    psql -c "SELECT 1" -h localhost -p 5432 -w -U postgres > /dev/null
    OK=$?
    rm $PGPASSFILE
    exit $OK
  END

  action :run
end
