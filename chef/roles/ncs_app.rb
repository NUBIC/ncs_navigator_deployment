name "ncs_app"
description "Application server nodes for the NCS Navigator application suite"

run_list(
  "role[ncs_common]",
  "recipe[build-essential]",
  "recipe[postgresql::client]",
  "recipe[rvm::system]",
  "recipe[apache2]",
  "recipe[passenger::apache2-rvm]",
  "recipe[tomcat]",
  "recipe[application_users]",
  "recipe[bcdatabase]",
  "recipe[aker::central]",
  "recipe[ssl_certificates]",
  "recipe[iptables]",
  "recipe[iptables::ssh]",
  "recipe[iptables::https]"
)

default_attributes(
  "postgresql" => {
    "version" => "9.0"
  },
  "passenger" => {
    "rvm_ruby_string" => "1.9.3-p194",
    "version" => "3.0.12"
  },
  "rvm" => {
    "default_ruby" => "system",
    "rubies" => ["1.9.3-p194"],
    "global_gems" => [
        { "name" => "bundler", "version" => "~> 1.1" }
     ]
  },
  "application_users" => {
    "users" => {
      "ncs_navigator_core" => {},
      "ncs_staff_portal" => {},
      "psc" => {}
    }
  },
  "bcdatabase" => {
    "version" => "1.2.1"
  },
  "aker" => {
    "central" => {
      "path" => "/etc/nubic/aker-prod.yml"
    }
  }
)
