include Chef::Logstash::Paths

action :create do
  config = new_resource.config
  role = new_resource.role

  ruby_block "add_logstash_#{role}_output_#{new_resource.name}" do
    block do
      node["logstash"][role]["output"] << config
      node.save unless Chef::Config[:solo]
    end

    notifies :create, resources(:template => logstash_conf_path(role))
  end
end
