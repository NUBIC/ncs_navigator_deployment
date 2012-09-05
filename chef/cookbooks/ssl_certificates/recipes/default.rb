#
# Cookbook Name:: ssl_certificates
# Recipe:: default
#
# Copyright 2011, Northwestern University
ca_path = node[:ssl_certificates][:ca_path]
trust_chain = node[:ssl_certificates][:trust_chain]

paths = trust_chain.map { |c| "#{ca_path}/#{c}" }

paths.each do |cert_path|
  # Install each certificate for later use by e.g. Java keystore recipes...
  cookbook_file cert_path do
    action :create
    mode 0444
  end

  # ...install lookup links for OpenSSL...
  ssl_certificates cert_path do
    action :trust
  end
end

# ...and then build the bundle.
#
# We need both of these to occur because we want to present a certificate chain
# to HTTP clients, but we want to use the same certificates in Java trust
# stores and keytool will not read multiple certificates out of a single file.
bash "build CA bundle" do
  code <<-END
  umask 0333
  cat #{paths.join(' ')} > #{node[:ssl_certificates][:ca_bundle]}
  END
end
