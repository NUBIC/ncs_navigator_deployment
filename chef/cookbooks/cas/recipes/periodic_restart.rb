#
# Cookbook Name:: cas
# Recipe:: periodic_restart
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


# If you've got misbehaving components in your CAS server, you might have to
# periodically kick it in the head until you can figure out what's wrong with
# it.
#
# This recipe does so every Sunday at midnight.
cron "periodic_cas_restart" do
  action :create
  user "root"
  command "monit restart cas_via_tomcat"
  hour "0"
  minute "00"
  weekday "0"
end
