require 'yaml'

action :create_if_missing do
  extend Chef::Bcdatabase::GroupHelpers

  gn = new_resource.group
  file_group = node[:bcdatabase][:app_group]

  file filename_for_group(gn) do
    action :create_if_missing
    group file_group
    mode node[:bcdatabase][:group_mode]
  end
end

action :update do
  extend Chef::Bcdatabase::GroupHelpers

  gn = new_resource.group
  data = new_resource.data
  file_group = node[:bcdatabase][:app_group]

  file filename_for_group(gn) do
    action :create
    content data.to_yaml
    group file_group
    mode node[:bcdatabase][:group_mode]
  end
end

action :encrypt do
  extend Chef::Bcdatabase::GroupHelpers

  gn = new_resource.group
  fn = filename_for_group(gn)

  execute "encrypt bcdatabase group #{gn}" do
    command "bcdatabase encrypt #{fn} #{fn}"
  end
end
