#
# Cookbook Name:: ncs_navigator
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

# If we're running in development, set up a development environment.
# We do this using node attributes, not environments, because Chef Solo doesn't
# do environments, and it's convenient to not have developer machines depend on
# a Chef server.
if node["development"]
  include_recipe "ncs_navigator::devenv"
end

include_recipe "ncs_navigator::app"
include_recipe "ncs_navigator::diagnostic_users"
