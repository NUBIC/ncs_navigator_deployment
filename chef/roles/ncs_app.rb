name "ncs_app"
description "Application server nodes for the NCS Navigator application suite"

run_list(
  "role[ncs_common]",
  "recipe[build-essential]",
  "recipe[postgresql::client]",
  "recipe[rvm::system]",
  "recipe[apache2]",
  "recipe[passenger::apache2]"
)

default_attributes(
  "postgresql" => {
    "version" => "9.0"
  },
  "rvm" => {
    "default_ruby" => "system",
    "rubies" => ["1.9.3-p194"],
    "global_gems" => [
        { "name" => "bundler", "version" => "~> 1.1" }
     ]
  }
)
