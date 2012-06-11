action :create do
  group_name = node[:application_user][:group]
  shell = new_resource.shell || node[:application_user][:shell]
  ssh_key_databag = new_resource.ssh_key_databag || node[:application_user][:ssh_key_databag]
  groups = [group_name] + new_resource.groups
  names_of_keys = new_resource.authorized_keys
  username = new_resource.name

  keys = names_of_keys.map { |name| data_bag_item(ssh_key_databag, name) }.compact
  home_dir = "/home/#{username}"
  ssh_dir = "#{home_dir}/.ssh"

  user username do
    comment "Application user"
    home home_dir
    shell shell
    supports :manage_home => true
    system true
  end

  directory ssh_dir do
    owner username
  end

  template "#{ssh_dir}/authorized_keys" do
    mode 0444
    owner username
    source "authorized_keys.erb"
    cookbook "application_user"
    variables :keys => keys.map { |k| k['key'] }
  end

  groups.each do |g|
    group g do
      append true
      members username
    end
  end
end
