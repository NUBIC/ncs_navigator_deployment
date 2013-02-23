#
# Cookbook Name:: ncs_navigator
# Recipe:: postgresql_env
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

# Set the default host for psql and friends.
template "/etc/profile.d/postgresql.sh" do
  source "postgresql.sh.erb"
  variables :host => node["ncs_navigator"]["db"]["host"]
  mode 0644
end
