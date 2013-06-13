name "ncs_app"
description "Application server nodes for the NCS Navigator application suite"

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
  recipe[ncs_navigator]
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
    "version" => "3.0.12",
    "max_pool_size" => 10
  },
  "ncs_navigator" => {
    "core" => {
      "database" => {
        "pool" => 5
      },
      "passenger" => {
        "min_instances" => 6
      }
    }
  },
  "rvm" => {
    "default_ruby" => "system",
    "global_gems" => [
        { "name" => "bundler", "version" => "~> 1.1" }
     ],
     "rvmrc" => {
        'rvm_project_rvmrc' => '0'
     },
     "branch" => "none"
  },
  "bcdatabase" => {
    "version" => "1.2.1"
  },
  "ncs_navigator_nubic" => {
    "deploy_monitor" => {
      "monitor" => {
        "cases" => true,
        "ops" => true
      }
    }
  }
)
