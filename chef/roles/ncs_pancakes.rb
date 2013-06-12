name "ncs_pancakes"
description "NCS Navigator Pancakes application server"

run_list %w(
  recipe[build-essential]
  recipe[postgresql::client]
  recipe[redisio::install]
  recipe[redisio::enable]
  recipe[rvm::system]
  recipe[apache2]
  recipe[bcdatabase]
  recipe[ssl_certificates]
  recipe[ncs_navigator::pancakes]
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
  "redisio" => {
    "version" => "2.6.13",
    "safe_install" => true,
    "servers" => [
      { "port" => "6379",
        "address" => "127.0.0.1"
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
  },
  "ncs_navigator_nubic" => {
    "deploy_monitor" => {
      "pancakes" => true
    }
  }
)
