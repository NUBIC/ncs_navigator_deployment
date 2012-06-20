require 'uri'

include_attribute "ssl_certificates"
include_attribute "apache2"
include_attribute "tomcat"

# The source file.
default[:cas][:war][:source] = "http://download.nubic.northwestern.edu/nubic_cas/nubic-cas-server-webapp-3.4.3.NUBIC-002.war"
default[:cas][:war][:checksum] = "ede527851672abbfdf00cf80635c81c7bfb4bb3729733c26eae9ee116bd6a8d0"

# NetID configuration.
default[:netid][:user] = ""
default[:netid][:password] = ""

# CAS server configuration.
# Note: don't set a database password here; a password is generated by the
# database recipe.
default[:cas][:dir] = "/etc/nubic/cas-server"
default[:cas][:bcsec] = "#{node[:cas][:dir]}/bcsec.rb"
default[:cas][:log] = "/var/log/cas/nubic-cas.log"

# Note: This isn't derived from cas[:dir] because the properties file MUST be
# present at this location to take effect.
default[:cas][:properties] = "/etc/nubic/cas-server/cas.properties"

# This path MUST NOT be prefixed with /, as it's also used to derive WAR
# filenames.
if node[:cas][:base_url]
  default[:cas][:script_name] = URI.parse(node[:cas][:base_url]).path.sub(%r{^/}, '')
end

# Ditto.
if node[:cas][:proxy_callback_url]
  pcu = node[:cas][:proxy_callback_url]

  default[:cas][:callback][:script_name] = URI.parse(pcu).path.sub(%r{^/}, '').split('/').first
end

# Database configuration.
default[:cas][:database][:name] = "nubic_cas"
default[:cas][:database][:user] = "nubic_cas"
default[:cas][:database][:bcdatabase][:group] = "local_postgresql"

# Apache.
default[:cas][:apache][:document_root] = "/var/www"
default[:cas][:apache][:configuration] = "#{node[:apache][:dir]}/sites-available/cas"

# Proxy callback.
default[:cas][:callback][:user] = "cas"
default[:cas][:callback][:app_path] = "#{node[:cas][:apache][:document_root]}/apps/cas-proxy-callback"
default[:cas][:callback][:pstore_path] = "/var/db/cas/pgt.pstore"

# Development-only configuration.
default[:cas][:devenv][:ssl][:certificate] = "#{node[:ssl_certificates][:ca_path]}/cas.crt"
default[:cas][:devenv][:ssl][:key] = "#{node[:ssl_certificates][:key_path]}/cas.key"
default[:cas][:devenv][:static_authority][:path] = "#{node[:cas][:dir]}/static.yml"
