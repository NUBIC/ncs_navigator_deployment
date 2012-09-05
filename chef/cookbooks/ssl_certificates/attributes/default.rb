default[:ssl_certificates][:ca_path] = "/etc/pki/tls/certs"
default[:ssl_certificates][:key_path] = "/etc/pki/tls/private"
default[:ssl_certificates][:ca_bundle] = node[:ssl_certificates][:ca_path] + "/ca_bundle.crt"

set[:ssl_certificates][:trust_chain] = %W(
  Equifax_Secure_Certificate_Authority.pem
  GeoTrust_Global_CA.pem
  rapidssl.crt
)
