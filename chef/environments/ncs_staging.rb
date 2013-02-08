name "ncs_staging"
description "Staging environment"

override_attributes(
  'postgresql' => {
    'package_version' => '9.1.8-1PGDG.rhel6'
  }
)
