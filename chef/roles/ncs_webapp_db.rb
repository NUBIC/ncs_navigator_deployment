name "ncs_webapp_db"
description "Database server for all NCS Navigator webapps"

run_list %w(
  role[ncs_common]
  recipe[build-essential]
  recipe[postgresql::server]
  recipe[iptables::db]
  recipe[ncs_navigator::db]
  role[ncs_chef_managed]
)

override_attributes(
  'postgresql' => {
    'interfaces' => ['*']
  }
)
