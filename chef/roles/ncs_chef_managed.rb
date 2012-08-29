name "ncs_chef_managed"
description "Sets the Chef client to our preferred mode of operation; also does cleanup of initial state"

run_list(%w(
  recipe[chef-client]
  recipe[chef-client::delete_validation]
))

default_attributes(
  "chef_client" => {
    "interval" => 1800
  }
)

