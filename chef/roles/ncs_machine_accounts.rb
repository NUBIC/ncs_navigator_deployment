require 'yaml'

name "ncs_machine_accounts"
description "A node running processes that use or accept NCS Navigator machine accounts"

run_list(%w(
  recipe[ncs_navigator::machine_accounts]
))

# You MUST NOT assign passwords here.  Instead, do that in role files:
#
#     override_attributes({
#       "ncs_navigator" => {
#         "machine_accounts" => {
#           "data" => {
#             "users" => {
#               "cases_merge" => {
#                 "password" => "supersecret"
#               }
#             }
#           }
#         }
#       }
#     })
account_data = YAML.load(%q{
users:
  cases_merge:
    portals:
      - NCSNavigator: []
})

default_attributes(
  "ncs_navigator" => {
    "machine_accounts" => {
      "data" => account_data
    }
  }
)
