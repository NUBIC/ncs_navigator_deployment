#
# Cookbook Name:: postgresql
# Provider:: hba
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

action :create do
  postgresql_hba_dir = "#{node["postgresql"]["dir"]}/pg_hba.d"

  directory postgresql_hba_dir do
    action :create
    recursive true
  end

  content = [
    new_resource.type,
    new_resource.database,
    new_resource.user
  ]

  if new_resource.type != 'local'
    content << new_resource.cidr_address
  end

  content << new_resource.method
  content << new_resource.options.map { |k, v| %Q{#{k}="#{v}"} }.join(' ')

  file "#{postgresql_hba_dir}/#{new_resource.name}" do
    action :create
    content content.join("\t")

    notifies :rebuild, new_resource
  end
end

action :delete do
  postgresql_hba_dir = "#{node["postgresql"]["dir"]}/pg_hba.d"

  file "#{postgresql_hba_dir}/#{new_resource.name}" do
    action :delete

    notifies :rebuild, new_resource
  end
end

action :rebuild do
  pg_hba = "#{node["postgresql"]["dir"]}/pg_hba.conf"
  postgresql_hba_dir = "#{node["postgresql"]["dir"]}/pg_hba.d"
  version = node["postgresql"]["version"]

  file pg_hba do
    action :create
    mode 0600
    owner "postgres"
    group "postgres"
  end

  ruby_block "rebuild_pg_hba" do
    action :create

    block do
      data = Dir["#{postgresql_hba_dir}/*"].sort.map { |fn| ::File.read(fn) }.join("\n")

      ::File.open("#{node[:postgresql][:dir]}/pg_hba.conf", 'w') do |f|
        f.write(data)
      end
    end

    notifies :send_notification, new_resource, :immediately
    notifies :reload, resources(:service => "postgresql-#{version}"), :immediately
  end
end

action :send_notification do
  new_resource.updated_by_last_action(true)
end
