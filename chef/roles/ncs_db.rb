name "ncs_db"
description "Database server nodes for the NCS Navigator application suite"

run_list(
  "role[ncs_common]",
  "recipe[postgresql::server]",
  "recipe[redisio::install]",
  "recipe[iptables]",
  "recipe[iptables::ssh]",
  "recipe[iptables::db]"
)

default_attributes(
  'postgresql' => {
    'interfaces' => ['*']
  },
  'redisio' => {
    'version' => '2.4.14'
  }
)
