#
# Cookbook Name:: ssl_certificates
# Recipe:: default
#
# Copyright 2011, Northwestern University

ca_path = node[:ssl_certificates][:ca_path]
trust_chain = node[:ssl_certificates][:trust_chain]

trust_chain.each do |cert|
  cookbook_file "#{ca_path}/#{cert}" do
    action :create
    mode 0444
  end
end

# Install certificates.
ssl_certificates trust_chain do
  action :install
end
