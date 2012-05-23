name "ncs_app"
description "Application server nodes for the NCS Navigator application suite"

run_list(
  "role[ncs_common]",
  "recipe[build-essential]"
)
