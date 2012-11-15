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
  recipe[ncs_navigator::cas_machine_accounts]
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
    "rvm_ruby_string" => "ruby-1.9.3-p327",
    "version" => "3.0.12"
  },
  "rvm" => {
    "default_ruby" => "system",
    "rubies" => ["ruby-1.9.3-p327"],
    "global_gems" => [
        { "name" => "bundler", "version" => "~> 1.1" }
     ],
     "rvmrc" => {
        'rvm_project_rvmrc' => '0'
     },
     "branch" => "none",
     "version" => "1.16.20",
     "upgrade_strategy" => "1.16.20"
  }
)
