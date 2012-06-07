include_attribute "nodejs"

default[:logio][:dir] = node[:nodejs][:dir]
default[:logio][:harvester][:user] = "logio"
default[:logio][:harvester][:log_file_paths] = {}
default[:logio][:harvester][:conf] = "/etc/log.io/harvester.conf"
