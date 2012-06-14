#
# Cookbook Name:: yumrepo
# Recipe:: repoforge
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

remote_file "/tmp/repoforge.rpm" do
  source "http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm"
  checksum "8e9b34285a0251e777a39e65b8d76ba6cd6ca22a0d2eb7c8c153bd5023d6d952"
end

rpm_package "repoforge" do
  action :install
  package_name "/tmp/repoforge.rpm"
end
