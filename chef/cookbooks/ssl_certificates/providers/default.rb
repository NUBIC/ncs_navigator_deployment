action :trust do
  path = new_resource.name
  dir = ::File.dirname(path)

  script "trust certificate #{path}" do
    interpreter "bash"
    user "root"
    code <<-END
      hash=`openssl x509 -hash -in #{path} -noout`
      target="#{dir}/$hash.0"

      ln -sf #{path} $target
    END
  end
end

action :untrust do
  path = new_resource.name
  dir = ::File.dirname(path)

  script "untrust certificate #{path}" do
    interpreter "bash"
    user "root"
    code <<-END
      hash=`openssl x509 -hash -in #{path} -noout`
      target="#{dir}/$hash.0"

      rm -f $target
    END
  end
end
