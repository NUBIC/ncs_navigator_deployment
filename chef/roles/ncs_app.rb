name "ncs_app"
description "Application server nodes for the NCS Navigator application suite"

base_run_list = %w(
  role[ncs_common]
  recipe[build-essential]
  recipe[postgresql::client]
  recipe[rvm::system]
  recipe[apache2]
  recipe[passenger::apache2-rvm]
  recipe[tomcat]
  recipe[bcdatabase]
  recipe[ssl_certificates]
  recipe[ncs_navigator::app]
  recipe[ncs_navigator::diagnostics_users]
  recipe[iptables::http]
  recipe[iptables::https]
)

env_run_lists(
  "ncs_development" => [
    "role[ncs_common]",
    "recipe[ncs_navigator::devenv]",
    base_run_list
  ].flatten,
  "_default" => base_run_list
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
    "rvm_ruby_string" => "ruby-1.9.3-p194",
    "version" => "3.0.12"
  },
  "rvm" => {
    "default_ruby" => "system",
    "rubies" => ["ruby-1.9.3-p194"],
    "global_gems" => [
        { "name" => "bundler", "version" => "~> 1.1" }
     ]
  },
  "bcdatabase" => {
    "version" => "1.2.1"
  }
)
