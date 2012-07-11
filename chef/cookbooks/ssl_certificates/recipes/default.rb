#
# Cookbook Name:: ssl_certificates
# Recipe:: default
#
# Copyright 2011, Northwestern University

ca_path = node[:ssl_certificates][:ca_path]
trust_chain = node[:ssl_certificates][:trust_chain]

paths = trust_chain.map { |c| "#{ca_path}/#{c}" }

paths.each do |cert_path|
  cookbook_file cert_path do
    action :create
    mode 0444
  end

  ssl_certificates cert_path do
    action :trust
  end
end
