name "ncs_db"
description "Database server nodes for the NCS Navigator application suite"

run_list(
  "role[ncs_common]",
  "recipe[postgresql::server]"
)

default_attributes(
  'postgresql' => {
    'interfaces' => ['*']
  }
)
