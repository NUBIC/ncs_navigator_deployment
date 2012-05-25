#
# Cookbook Name:: ssl_certificates
# Recipe:: selinux
#
# Copyright 2011, Northwestern University

include_recipe "selinux"

ca_path = node[:ssl_certificates][:ca_path]

selinux_security_context ca_path do
  action :restore
end
