#
# Cookbook Name:: ssl_certificates
# Recipe:: default
#
# Copyright 2011, Northwestern University

ca_path = node[:ssl_certificates][:ca_path]
c1 = "#{ca_path}/go_daddy_secure_certification_authority.crt"
c2 = "#{ca_path}/go_daddy_class_2_certification_authority.crt"

# Subject:
#   C=US, ST=Arizona, L=Scottsdale, O=GoDaddy.com, Inc.,
#     OU=http://certificates.godaddy.com/repository, CN=Go Daddy Secure
#     Certification Authority/serialNumber=0796928
#
# Issuer:
#   C=US, O=The Go Daddy Group, Inc., OU=Go Daddy Class 2 Certification
#   Authority
# 
# MD5 Fingerprint=D5:DF:85:B7:9A:52:87:D1:8C:D5:0F:90:23:2D:B5:34
# SHA1 Fingerprint=7C:46:56:C3:06:1F:7F:4C:0D:67:B3:19:A8:55:F6:0E:BC:11:FC:44
cookbook_file c1 do
  action :create
  mode 0444
end

# Subject:
#   C=US, O=The Go Daddy Group, Inc., OU=Go Daddy Class 2 Certification
#   Authority
#
# Issuer:
#   L=ValiCert Validation Network, O=ValiCert, Inc., OU=ValiCert Class 2
#   Policy Validation Authority,
#   CN=http://www.valicert.com//emailAddress=info@valicert.com
#
# MD5 Fingerprint=82:BD:9A:0B:82:6A:0E:3E:91:AD:3E:27:04:2B:3F:45
# SHA1 Fingerprint=DE:70:F4:E2:11:6F:7F:DC:E7:5F:9D:13:01:2B:7E:68:7A:3B:2C:62
#
# This certificate's issuer is shipped in RHEL 6.1's trusted CA certificate
# bundle, so we don't need to install the certificate for the issuer.
cookbook_file c2 do
  action :create
  mode 0444
end

# Install certificates.
ssl_certificates [c1, c2] do
  action :install
end
