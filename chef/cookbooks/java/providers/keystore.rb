action :import do
  keystore = new_resource.keystore
  password = new_resource.storepass
  cert_file = new_resource.cert_file
  cert_alias = new_resource.cert_alias
  user = new_resource.user

  keytool = "#{node["java"]["java_home"]}/bin/keytool"

  already_has_cert_command = [
    keytool,
    "-list",
    "-keystore '#{keystore}'",
    "-storepass '#{password}'",
    "-alias '#{cert_alias}'"
  ].join(' ')

  import_command = [
    keytool,
    "-import",
    "-file '#{cert_file}'",
    "-alias '#{cert_alias}'",
    "-keystore '#{keystore}'",
    "-storepass '#{password}'",
    "-noprompt"
  ].join(' ')

  execute import_command do
    user user
    not_if already_has_cert_command
  end
end
