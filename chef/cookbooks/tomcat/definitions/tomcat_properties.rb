define :tomcat_properties, :action => :enable do
  include_recipe "tomcat"

  properties_defs = node["tomcat"]["catalina_properties"]["defs"]
  properties_file = node["tomcat"]["catalina_properties"]["file"]

  directory properties_defs do
    action :create
    recursive true
  end

  directory ::File.dirname(properties_file) do
    action :create
    recursive true
  end

  # If the file doesn't exist, we need to rebuild it from whatever might be
  # present.
  file properties_file do
    action :create_if_missing

    notifies :create, resources(:ruby_block => 'rebuild_tomcat_properties')
  end

  if params[:properties]
    file "#{properties_defs}/#{params[:name]}" do
      action :create
      content params[:properties].join("\n")

      notifies :create, resources(:ruby_block => 'rebuild_tomcat_properties')
    end
  elsif params[:source]
    template "#{properties_defs}/#{params[:name]}" do
      action :create
      source params[:source]

      notifies :create, resources(:ruby_block => 'rebuild_tomcat_properties')
    end
  end
end
