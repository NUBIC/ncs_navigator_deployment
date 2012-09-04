default[:ssl_certificates][:ca_path] = "/etc/pki/tls/certs"
default[:ssl_certificates][:key_path] = "/etc/pki/tls/private"

# rapidssl.crt
# SHA1 Fingerprint=C0:39:A3:26:9E:E4:B8:E8:2D:00:C5:3F:A7:97:B5:A1:9E:83:6F:47
# MD5 Fingerprint=1B:EE:28:5E:8F:F8:08:5F:79:CC:60:8B:92:99:A4:53

# geotrust.crt
# SHA1 Fingerprint=73:59:75:5C:6D:F9:A0:AB:C3:06:0B:CE:36:95:64:C8:EC:45:42:A3
# MD5 Fingerprint=2E:7D:B2:A3:1D:0E:3D:A4:B2:5F:49:B9:54:2A:2E:1A

default[:ssl_certificates][:trust_chain] = %W(
  rapidssl.crt
  geotrust.crt
)
