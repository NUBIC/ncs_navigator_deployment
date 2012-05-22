name "ncs_common"
description "Common recipes for nodes in the NCS Navigator application suite"

run_list(
  "recipe[ntp]",
  "recipe[ntp::selinux]"
)

default_attributes(
  "ntp" => {
    "servers" => ["time.northwestern.edu"]
  }
)
