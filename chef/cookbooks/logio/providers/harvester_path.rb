action :add do
  key = new_resource.name
  path = new_resource.path

  node[:logio][:harvester][:log_file_paths][key] = path
  node.save unless Chef::Config[:solo]

  ruby_block "add logfile #{key} to logio harvester" do
    block { }
    
    action :nothing
    notifies :create, resources(:template => node[:logio][:harvester][:conf])
  end
end

action :remove do
  key = new_resource.name

  node[:logio][:harvester][:log_file_paths].delete(key)
  node.save unless Chef::Config[:solo]

  ruby_block "remove logfile #{key} from logio harvester" do
    block { }
    
    action :nothing
    notifies :create, resources(:template => node[:logio][:harvester][:conf])
  end
end
