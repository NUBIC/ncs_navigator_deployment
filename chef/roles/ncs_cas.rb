name "ncs_cas"
description "The CAS server for the NCS Navigator application suite"

run_list(%w(
  role[ncs_common]
  recipe[build-essential]
  recipe[postgresql::server]
  recipe[rvm::system]
  recipe[apache2]
  recipe[apache2::single_access_log]
  recipe[passenger::apache2-rvm]
  recipe[tomcat]
  recipe[cas]
  recipe[iptables::http]
  recipe[iptables::https]
  recipe[ncs_navigator::cas_machine_accounts]
  recipe[cas::periodic_restart]
  role[ncs_chef_managed]
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
    "version" => "3.0.12"
  },
  "rvm" => {
    "default_ruby" => "system",
    "global_gems" => [
        { "name" => "bundler", "version" => "~> 1.1" }
     ],
     "rvmrc" => {
        'rvm_project_rvmrc' => '0'
     },
     "branch" => "none"
  }
)
