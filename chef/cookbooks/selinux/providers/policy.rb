action :create do
  policy_name = new_resource.name
  policy_version = new_resource.version
  policy_string = new_resource.policy
  policy_file = new_resource.policy_file

  unless policy_string || policy_file
    raise "You must provide either a policy or path to a file containing a policy"
  end

  # The SELinux policy makefile builds all policies in a directory,
  # so we increase the chances that we've got a clean one.
  policy_scratch_dir = "/tmp/selinux-policy-#{rand.to_s}"
  tempfile = "#{policy_scratch_dir}/#{policy_name}.te"

  # If the policy scratch directory already exists, clean it out.
  directory policy_scratch_dir do
    action :delete
    recursive true
  end

  directory policy_scratch_dir do
    action :create
    mode 0700
    owner "root"
  end

  # If the policy was specified inline, write it out.
  # If the policy is provided by a file in the cookbook, copy it to `tempfile`
  # and prepend the policy header.
  policy_header = "policy_module(#{policy_name},#{policy_version})"

  if policy_string
    file tempfile do
      content <<-END
      #{policy_header}

      #{policy_string}
      END
    end
  else
    cookbook_file tempfile do
      source policy_file
    end

    ruby_block "add policy header to #{tempfile}" do
      block do
        old_data = ::File.read(tempfile)

        ::File.open(tempfile, 'w') do |f|
          f.write <<-END
          #{policy_header}

          #{old_data}
          END
        end
      end
    end
  end

  # Build and install the module if it doesn't already exist.
  script "install policy #{policy_name}, version #{policy_version}" do
    interpreter "bash"
    user "root"
    cwd policy_scratch_dir
    code <<-END
    make -f #{node[:selinux][:makefile]}

    set +e

    semodule -l | egrep -q '#{policy_name}'
    installed=$?

    set -e

    if [ $installed -ne 0 ]; then
      semodule -i #{policy_name}.pp
    else
      set +e

      semodule -l | egrep -q '#{policy_name}.*#{policy_version}'
      installed=$?

      set -e

      if [ $installed -ne 0 ]; then
        semodule -u #{policy_name}.pp
      fi
    fi
    END
  end

  # Clean up.
  directory policy_scratch_dir do
    action :delete
    recursive true
  end
end

action :delete do
  script "delete policy #{policy_name}" do
    interpreter "bash"
    user "root"

    code <<-END
    semodule -r #{policy_name}
    END
  end
end
