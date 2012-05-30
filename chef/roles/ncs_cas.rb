name "ncs_cas"
description "The CAS server for the NCS Navigator application suite"

run_list(
  "role[ncs_common]",
  "recipe[build-essential]",
  "recipe[postgresql::client]",
  "recipe[rvm::system]",
  "recipe[apache2]",
  "recipe[passenger::apache2-rvm]",
  "recipe[tomcat]",
  "recipe[application_users]",
  "recipe[iptables::https]"
)

default_attributes(
  "application_users" => {
    "users" => {
      "cas" => {}
    }
  },
  "passenger" => {
    "rvm_ruby_string" => "1.9.3-p194"
  },
  "rvm" => {
    "default_ruby" => "system",
    "rubies" => ["1.9.3-p194"],
    "global_gems" => [
        { "name" => "bundler", "version" => "~> 1.1" }
     ]
  }
)
