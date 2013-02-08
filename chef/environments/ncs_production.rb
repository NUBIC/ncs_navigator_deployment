name "ncs_production"
description "Production environment"

override_attributes(
  'postgresql' => {
    'package_version' => '9.1.6-1PGDG.rhel6'
  }
)
