name "ncs_app"
description "Application server nodes for the NCS Navigator application suite"

run_list(
  "role[ncs_common]",
  "recipe[build-essential]",
  "recipe[postgresql::client]",
  "recipe[rvm::system]",
  "recipe[passenger::apache2]"
)

default_attributes(
  "postgresql" => {
    "version" => "9.0"
  },
  "rvm" => {
    "default_ruby" => "1.9.3-p125",
    "global_gems" => [
        { "name" => "bundler" }
     ]
  }
)
