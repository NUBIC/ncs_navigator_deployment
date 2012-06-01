name "ncs_cas"
description "The CAS server for the NCS Navigator application suite"

run_list(
  "role[ncs_common]",
  "recipe[build-essential]",
  "recipe[postgresql::server]",
  "recipe[rvm::system]",
  "recipe[apache2]",
  "recipe[passenger::apache2-rvm]",
  "recipe[tomcat]",
  "recipe[application_users]",
  "recipe[cas::tomcat-apache]",
  "recipe[iptables::https]"
)

default_attributes(
  "bcdatabase" => {
    "group_mode" => "0644"
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
