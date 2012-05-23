name "ncs_common"
description "Common recipes for nodes in the NCS Navigator application suite"

run_list(
  "recipe[selinux::disabled]",
  "recipe[ntp]",
  "recipe[yumrepo::epel]",
  "recipe[monit]"
)

default_attributes(
  "ntp" => {
    "servers" => ["time.northwestern.edu"]
  },
  "monit" => {
    "poll_period" => 30,
    "poll_start_delay" => 5
  },
  "yum" => {
    "epel_release" => 6
  },
  "postgresql" => {
    "version" => "9.0"
  }
)
