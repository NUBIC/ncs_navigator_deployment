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
  "recipe[application_users]"
)

default_attributes(
  "application_users" => {
    "users" => {
      "cas" => {}
    }
  }
)
