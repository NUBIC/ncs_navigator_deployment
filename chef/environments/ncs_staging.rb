name "ncs_staging"
description "Staging environment"

default_attributes(
  'postgresql' => {
    'package_version' => '9.1.8-2PGDG.rhel6'
  }
)
