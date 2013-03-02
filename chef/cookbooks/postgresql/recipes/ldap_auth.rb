#
# Cookbook Name:: postgresql
# Recipe:: ldap_auth
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

include_recipe "postgresql::server"

ldap = node["postgresql"]["ldap"]

raise "LDAP for PostgreSQL not configured" unless ldap

node["postgresql"]["ldap"]["users"].each do |username, databases|
  postgresql_hba "10_ldap_auth_#{username}" do
    action :create
    database databases
    method "ldap"
    type "hostssl"
    user user
    options :ldapserver => ldap["server"],
            :ldapport => ldap["port"],
            :ldaptls => ldap["tls"],
            :ldapprefix => ldap["prefix"],
            :ldapsuffix => ldap["suffix"],
            :ldapbasedn => ldap["basedn"],
            :ldapbinddn => ldap["binddn"],
            :ldapbindpasswd => ldap["bindpasswd"],
            :ldapsearchattribute => ldap["searchattribute"]
  end
end
