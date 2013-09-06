name "ncs_staging"
description "Staging environment"

cookbook_versions(
  'ncs_navigator' => '~> 0.3.0'
)

default_attributes(
  'postgresql' => {
    'package_version' => '9.1.8-2PGDG.rhel6'
  }
)
