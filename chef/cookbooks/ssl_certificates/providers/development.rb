action :install do
  path = new_resource.name
  bn = new_resource.basename
  owner = new_resource.owner
  group = new_resource.group

  cookbook_file "#{path}/#{bn}.crt" do
    cookbook "ssl_certificates"
    group group
    mode 0444
    owner owner
    source "wildcard.local.crt"
  end

  cookbook_file "#{path}/#{bn}.key" do
    cookbook "ssl_certificates"
    group group
    mode 0400
    owner owner
    source "wildcard.local.key"
  end
end

action :uninstall do
  path = new_resource.name
  bn = new_resource.basename

  cookbook_file "#{path}/#{bn}.crt" do
    action :delete
  end

  cookbook_file "#{path}/#{bn}.key" do
    action :delete
  end
end
