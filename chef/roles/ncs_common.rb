name "ncs_common"
description "Common recipes for nodes in the NCS Navigator application suite"

run_list %w(
  recipe[cron]
  recipe[iptables]
  recipe[iptables::ssh]
  recipe[selinux::disabled]
  recipe[yumrepo::epel]
  recipe[yumrepo::repoforge]
  recipe[nubic-utils]
  recipe[monit]
)

default_attributes(
  "chef-client" => {
    "interval" => 1800
  },
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
