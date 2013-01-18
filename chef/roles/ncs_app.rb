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
