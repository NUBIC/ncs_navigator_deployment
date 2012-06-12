name "ncs_db"
description "Database server nodes for the NCS Navigator application suite"

run_list(
  "role[ncs_common]",
  "recipe[postgresql::server]",
  "recipe[redisio::install]",
  "recipe[redisio::enable]",
  "recipe[ncs_navigator::db_server]",
  "recipe[iptables::db]"
)

default_attributes(
  'redisio' => {
    'version' => '2.4.14',
    'safe_install' => true
  }
)

override_attributes(
  'postgresql' => {
    'interfaces' => ['*']
  }
)
