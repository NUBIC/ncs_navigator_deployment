name "ncs_ops_psc"
description "NCS Navigator Ops and PSC application servers"

run_list %w(
  role[ncs_common]
  recipe[build-essential]
  recipe[postgresql::client]
  recipe[rvm::system]
  recipe[apache2]
  recipe[apache2::single_access_log]
  recipe[passenger::apache2-rvm]
  recipe[tomcat]
  recipe[bcdatabase]
  recipe[ssl_certificates]
  recipe[ncs_navigator::ops]
  recipe[ncs_navigator::psc]
  recipe[ncs_navigator::ops_psc_ini]
  recipe[ncs_navigator::postgresql_env]
  recipe[ncs_navigator::cas_client_monitoring]
  recipe[ncs_navigator::db_client_monitoring]
  recipe[ncs_navigator::https_redirect]
  recipe[iptables::http]
  recipe[iptables::https]
  recipe[gperftools]
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
