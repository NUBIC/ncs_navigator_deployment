require 'yaml'

action :create do
  extend Chef::Bcdatabase::GroupHelpers

  gn = new_resource.group
  file_group = node[:bcdatabase][:app_group]

  unless group_present?(gn)
    data = { 'defaults' => new_resource.defaults.to_hash }

    file filename_for_group(gn) do
      mode 0640
      group file_group
      content data.to_yaml
    end
  end
end

action :update do
  extend Chef::Bcdatabase::GroupHelpers

  gn = new_resource.group
  data = new_resource.data
  file_group = node[:bcdatabase][:app_group]

  file filename_for_group(gn) do
    mode 0640
    group file_group
    content data.to_hash.to_yaml
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
