#
# Cookbook Name:: ncs_navigator
# Recipe:: db
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

include_recipe "monit"
include_recipe "postgresql::server"
include_recipe "database"
include_recipe "redisio"

# Build an administrative user for NCS Navigator provisioning.  This user is
# able to create databases and other users (needed to set up permissions) and
# has the following important differences from the postgres user:
#
# 1. It is not a superuser.
# 2. It may log in from non-localhost origins.

db_admin = node["ncs_navigator"]["db"]["admin"]["user"]
db_password = node["ncs_navigator"]["db"]["admin"]["password"]

raise "#{db_admin} password not set" if db_password.nil?

connection_info = {
  :host => "localhost",
  :username => "postgres",
  :password => node["postgresql"]["password"]["postgres"]
}

postgresql_database_user db_admin do
  action :create
  connection connection_info
  password db_password
  options 'CREATEROLE'
end

# Monitor PostgreSQL.
pg_version = node["postgresql"]["version"]
monitrc "monitor_postgres", :pid => "/var/run/postmaster-#{pg_version}.pid", :version => pg_version

# Monitor Redis.
node["redisio"]["servers"].each do |server|
  port = server['port']

  monitrc "monitor_redis_#{port}", :pid => "/var/run/redis/redis_#{port}.pid", :port => port
end

# That's all we need to do here.  Cases, PSC, and Ops will register their own
# databases using the db admin user.  See their recipes for more information.
