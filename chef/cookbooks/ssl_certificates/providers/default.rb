action :install do
  certificate_paths = new_resource.name
  ca_path = node[:ssl_certificates][:ca_path]

  certificate_paths.each do |path|
    script "install certificate #{path}" do
      interpreter "bash"
      user "root"
      code <<-END
        hash=`openssl x509 -hash -in #{path} -noout`
        target="#{ca_path}/$hash.0"

        ln -sf #{path} $target
      END
    end
  end
end

action :uninstall do
  certificate_paths = new_resource.name
  ca_path = node[:ssl_certificates][:ca_path]

  certificate_paths.each do |path|
    script "uninstall certificate #{path}" do
      interpreter "bash"
      user "root"
      code <<-END
        hash=`openssl x509 -hash -in #{path} -noout`
        target="#{ca_path}/$hash.0"

        rm -f $target
      END
    end
  end
end
