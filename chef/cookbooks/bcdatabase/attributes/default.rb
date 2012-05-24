default[:bcdatabase][:app_group] = node[:application_users][:group] || "app"
default[:bcdatabase][:directory] = "/etc/nubic/db"
default[:bcdatabase][:groups] = {}
default[:bcdatabase][:version] = ">= 0"
