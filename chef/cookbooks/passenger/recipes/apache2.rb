#
# Cookbook Name:: passenger
# Recipe:: apache2

# Derives from the opsware passenger_apache2

include_recipe "apache2"

if platform?("centos","redhat")
  %w(httpd-devel curl-devel).each do |pkg|
    package pkg
  end
else
  %w{ apache2-prefork-dev libapr1-dev libcurl4-openssl-dev }.each do |pkg|
    package pkg do
      action :upgrade
    end
  end
end

include_recipe "passenger::install"

rvm_exec_prefix = system("test -e /usr/local/rvm") ? "/usr/local/rvm/bin/rvm default exec" : ""

bash "install passenger/apache2" do
  user "root"
  code "#{rvm_exec_prefix} passenger-install-apache2-module --auto"
  creates "#{node[:passenger][:module_path]}"
end

template "#{node[:apache][:dir]}/mods-available/passenger.load" do
  cookbook "passenger"
  source "apache.load.erb"
  owner "root"
  group "root"
  mode 0644
  only_if do ::File.exists?(node[:passenger][:root_path]) end
end

template "#{node[:apache][:dir]}/mods-available/passenger.conf" do
  cookbook "passenger"
  source "apache.conf.erb"
  owner "root"
  group "root"
  mode 0644
  only_if do ::File.exists?(node[:passenger][:root_path]) end
end

include_recipe "apache2"

if ::File.exists?(node[:passenger][:root_path])
  apache_module "passenger"
end


#log_path = node[:passenger][:production][:log_path]
#
#directory log_path do
#  mode 0755
#  action :create
#end

