#
# Cookbook Name:: ncs_navigator
# Definition:: ncs_navigator_bcdatabase_config
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

define :ncs_navigator_bcdatabase_config do
  config_hash = params[:config_hash]
  group = config_hash["group"]
  config = config_hash["config"]

  raise "Bcdatabase group not defined" unless group

  database = params[:database]
  password = params[:password]
  pool_size = params[:pool_size]
  username = params[:username]

  include_recipe "bcdatabase"

  bcdatabase_config "#{group}_#{config}" do
    action :create
    adapter "postgresql"
    config config
    database database
    datamapper_adapter "postgres"
    group group
    host node["ncs_navigator"]["db"]["host"]
    password password
    username username

    if pool_size
      pool pool_size
    end
  end
end
