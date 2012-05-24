#
# Cookbook Name:: bcdatabase
# Recipe:: default
#
# Copyright 2011, Northwestern University
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

key_dir = "/var/lib/nubic"
key_file = "#{key_dir}/db.pass"
app_group = node[:bcdatabase][:app_group]
version = node[:bcdatabase][:version]
groups = node[:bcdatabase][:groups]

script "install bcdatabase" do
  interpreter "bash"
  code <<-END
    gem install bcdatabase --no-rdoc --no-ri -v '#{version}'
  END

  not_if "gem list -i bcdatabase -v '#{version}'"
end

directory node[:bcdatabase][:directory] do
  recursive true
end

directory key_dir do
  recursive true
end

script "generate bcdatabase key" do
  interpreter "bash"
  cwd key_dir
  code <<-END
  env BCDATABASE_PASS=#{key_file} sh -c 'yes | bcdatabase gen-key'
  END

  not_if { File.exists?(key_file) }
end

file key_file do
  mode 0640
  group app_group
end

groups.each do |group, defaults|
  bcdatabase_group group do
    action :update
    defaults defaults
  end
end
