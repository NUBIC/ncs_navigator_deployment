name "ncs_production"
description "Production environment"

cookbook_versions(
  'ncs_navigator' => '0.2.0'
)

default_attributes(
  'postgresql' => {
    'package_version' => '9.1.6-1PGDG.rhel6'
  }
)
