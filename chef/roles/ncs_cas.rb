name "ncs_cas"
description "The CAS server for the NCS Navigator application suite"

run_list(
  "role[ncs_app]"
)
