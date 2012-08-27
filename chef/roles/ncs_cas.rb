name "ncs_cas"
description "The CAS server for the NCS Navigator application suite"

run_list(%w(
  role[ncs_common]
  role[ncs_machine_accounts]
  recipe[ncs_navigator::machine_accounts]
  recipe[build-essential]
  recipe[postgresql::server]
  recipe[rvm::system]
  recipe[apache2]
  recipe[passenger::apache2-rvm]
  recipe[tomcat]
  recipe[cas]
  recipe[iptables::http]
  recipe[iptables::https]
))

default_attributes(
  "bcdatabase" => {
    "app_group" => "tomcat"
  },
  "aker" => {
    "central" => {
      "group" => "tomcat"
    }
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
  }
)
