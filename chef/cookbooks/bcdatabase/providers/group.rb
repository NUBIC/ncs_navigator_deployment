require 'yaml'

action :update do
  conf_dir = node[:bcdatabase][:directory]
  file_group = node[:bcdatabase][:app_group]
  filename = "#{conf_dir}/#{new_resource.group}.yml"

  old_data = if ::File.exists?(filename)
               YAML.load(::File.read(filename))
             else
               {}
             end

  file filename do
    mode 0640
    group file_group
    content old_data.merge("defaults" => new_resource.defaults.to_hash).to_yaml
  end
end
