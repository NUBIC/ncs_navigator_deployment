#
# Cookbook Name:: postgresql
# Recipe:: client
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Lamont Granquist (<lamont@opscode.com>)
# Copyright 2009-2011 Opscode, Inc.
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

# More up-to-date packages are available for Redhat-like distributions at
# yum.postgresql.org, so we activate that repo first.
#
include_recipe "yumrepo::postgresql9"

version = node['postgresql']['version']
package_version = node['postgresql']['package_version']
designator = version.split('.').join

package "postgresql#{designator}" do
  version package_version
end

package "postgresql#{designator}-devel" do
  version package_version
end

# Register pg_config with the alternatives system.
#
# The PostgreSQL RPMs don't do this; not having it available in the default
# path breaks configure scripts and gem native extensions.
execute "alternatives --install /usr/bin/pg_config pgsql-pg_config /usr/pgsql-#{version}/bin/pg_config #{(version.to_f * 100).to_i}"

# Some versions of the 9.1.8 PGDG RPM don't properly install the ldpath where
# libpq is.  We remedy that if necessary.
execute "alternatives --install /etc/ld.so.conf.d/postgresql-pgdg-libs.conf pgsql-ld-conf /usr/pgsql-#{version}/share/postgresql-#{version}-libs.conf #{(version.to_f * 100).to_i}" do
  not_if { File.exists?('/etc/alternatives/pgsql-ld-conf') }
end

execute "ldconfig" do
  not_if { File.exists?('/etc/alternatives/pgsql-ld-conf') }
end

gem_package "pg" do
  action :install
end
