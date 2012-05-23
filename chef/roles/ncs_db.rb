name "ncs_db"
description "Database server nodes for the NCS Navigator application suite"

run_list(
  "role[ncs_common]",
  "recipe[postgresql::server]",
  "recipe[redisio::install]"
)

default_attributes(
  'postgresql' => {
    'interfaces' => ['*']
  },
  'redisio' => {
    'version' => '2.4.14'
  }
)
