name "ncs_common"
description "Common recipes for nodes in the NCS Navigator application suite"

base_run_list = %w(
  recipe[iptables]
  recipe[iptables::ssh]
  recipe[selinux::disabled]
  recipe[nubic-utils]
  recipe[yumrepo::epel]
  recipe[yumrepo::repoforge]
  recipe[monit]
)

env_run_lists(
  "development" => [
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
    "version" => "9.1"
  }
)
