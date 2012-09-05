#
# Cookbook Name:: ssl_certificates
# Recipe:: default
#
# Copyright 2011, Northwestern University
ca_path = node[:ssl_certificates][:ca_path]
trust_chain = node[:ssl_certificates][:trust_chain]

paths = trust_chain.map { |c| "#{ca_path}/#{c}" }

# Build the bundle.
#
# We need both the bundle and individual certificates because we want to
# present a certificate chain to HTTP clients, but we want to use the same
# certificates in Java trust stores and keytool will not read multiple
# certificates out of a single file.
#
# This is only run if any of the constituent certificates change or the bundle
# is missing.
script "build_trust_chain_bundle" do
  action :nothing
  code <<-END
  BUNDLE='#{node[:ssl_certificates][:trust_chain_bundle]}'

  for path in #{paths.join(' ')}; do
    cat $path >> $BUNDLE
    echo >> $BUNDLE
  done
  END
  interpreter "bash"
end

paths.each do |cert_path|
  # Install each certificate for later use by e.g. Java keystore recipes...
  cookbook_file cert_path do
    action :create
    mode 0444
    notifies :execute, resource(:script => "build_trust_chain_bundle]")
  end

  # ...and install lookup links for OpenSSL.
  ssl_certificates cert_path do
    action :trust
  end
end

# Build the bundle if necessary.
file node[:ssl_certificates][:trust_chain_bundle] do
  action :create_if_missing
  mode 0444

  notifies :execute, resource(:script => "build_trust_chain_bundle]")
end
