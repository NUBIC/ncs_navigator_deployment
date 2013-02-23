name "ncs_webapp_db"
description "Database server for all NCS Navigator webapps"

run_list %w(
  role[ncs_common]
  recipe[build-essential]
  recipe[postgresql::server]
  recipe[redisio::install]
  recipe[redisio::enable]
  recipe[iptables::db]
  recipe[ncs_navigator::db]
  role[ncs_chef_managed]
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
