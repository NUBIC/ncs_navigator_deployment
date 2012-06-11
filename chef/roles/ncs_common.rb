name "ncs_common"
description "Common recipes for nodes in the NCS Navigator application suite"

base_run_list = %w(
  recipe[iptables]
  recipe[iptables::ssh]
  recipe[selinux::disabled]
  recipe[ntp]
  recipe[screen]
  recipe[yumrepo::epel]
  recipe[monit]
)

env_run_lists(
  "ncs_development" => [
    base_run_list,
    "recipe[zeroconf]"
  ].flatten,
  "_default" => base_run_list
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
