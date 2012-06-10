include_attribute "application_user"

default[:bcdatabase][:app_group] = node[:application_user][:group] || "app"
default[:bcdatabase][:directory] = "/etc/nubic/db"
default[:bcdatabase][:groups] = {}
default[:bcdatabase][:version] = ">= 0"
default[:bcdatabase][:group_mode] = "0640"
