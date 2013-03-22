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
  source "http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm"
  checksum "1f98252908e397f70a216964ed836e93ba4e80550eac343586895a993a41afb7"
end

rpm_package "repoforge" do
  action :install
  package_name "/tmp/repoforge.rpm"
end
