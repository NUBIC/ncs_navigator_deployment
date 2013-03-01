name "ncs_cases"
description "Application server for NCS Navigator Cases"

run_list %w(
  role[ncs_common]
  recipe[build-essential]
  recipe[postgresql::client]
  recipe[redisio::install]
  recipe[redisio::enable]
  recipe[rvm::system]
  recipe[apache2]
  recipe[apache2::single_access_log]
  recipe[passenger::apache2-rvm]
  recipe[bcdatabase]
  recipe[ssl_certificates]
  recipe[gperftools]
  recipe[ncs_navigator::instruments]
  recipe[ncs_navigator::cases]
  recipe[ncs_navigator::cases_ini]
  recipe[ncs_navigator::warehouse]
  recipe[ncs_navigator::postgresql_env]
  recipe[ncs_navigator::cas_client_monitoring]
  recipe[ncs_navigator::db_client_monitoring]
  recipe[ncs_navigator::https_redirect]
  recipe[iptables::http]
  recipe[iptables::https]
  role[ncs_chef_managed]
)

default_attributes(
  "aker" => {
    "central" => {
      "path" => "/etc/nubic/ncs/aker-prod.yml"
    }
  },
  "application_user" => {
    "shell" => "/bin/bash"
  },
  'redisio' => {
    'version' => '2.4.14',
    'safe_install' => true,
    'servers' => [
      { 'port' => '6379',
        'address' => '127.0.0.1'
      }
    ]
  },
  "passenger" => {
    "rvm_ruby_string" => "ruby-1.9.3-p327",
    "version" => "3.0.12",
    "max_pool_size" => 10
  },
  "rvm" => {
    "default_ruby" => "system",
    "rubies" => ["ruby-1.9.3-p327"],
    "global_gems" => [
        { "name" => "bundler", "version" => "~> 1.1" }
     ],
     "rvmrc" => {
        'rvm_project_rvmrc' => '0'
     },
     "branch" => "none",
     "version" => "1.16.20",
     "upgrade" => "1.16.20"
  },
  "bcdatabase" => {
    "version" => "1.2.1"
  }
)
