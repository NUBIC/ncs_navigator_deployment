name "ncs_cas"
description "The CAS server for the NCS Navigator application suite"

base_run_list = %w(
  role[ncs_common]
  recipe[build-essential]
  recipe[application_users]
  recipe[postgresql::server]
  recipe[rvm::system]
  recipe[apache2]
  recipe[passenger::apache2-rvm]
  recipe[tomcat]
  recipe[cas]
  recipe[iptables::https]
)

env_run_lists(
  "ncs_development" => [
    "recipe[zeroconf]",
    base_run_list,
    "recipe[cas::devenv]"
  ].flatten,
  "_default" => base_run_list
)

default_attributes(
  "application_users" => {
    "users" => {
      "cas" => {},
      "tomcat" => {}
    }
  },
  "bcdatabase" => {
    "app_group" => "app"
  },
  "aker" => {
    "central" => {
      "group" => "app"
    }
  },
  "passenger" => {
    "rvm_ruby_string" => "ruby-1.9.3-p194",
    "version" => "3.0.12"
  },
  "postgresql" => {
    "version" => "9.0"
  },
  "rvm" => {
    "default_ruby" => "system",
    "rubies" => ["ruby-1.9.3-p194"],
    "global_gems" => [
        { "name" => "bundler", "version" => "~> 1.1" }
     ]
  }
)

override_attributes(
  "tomcat" => {
    "group" => "app"
  }
)
