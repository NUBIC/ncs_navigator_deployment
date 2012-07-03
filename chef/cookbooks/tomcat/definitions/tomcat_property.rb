define :tomcat_property, :action => :enable do
  include_recipe "tomcat"

  properties = params[:properties]

  ruby_block "Tomcat properties: #{properties.join(', ')}" do
    block do
      node["tomcat"]["custom_properties"] |= properties
      node.save unless Chef::Config[:solo]
    end

    not_if do
      properties.all? { |p| node["tomcat"]["custom_properties"].include?(p) }
    end

    notifies :create, resources(:template => node["tomcat"]["properties_file"])
    notifies :restart, resources(:service => "tomcat")
  end
end
