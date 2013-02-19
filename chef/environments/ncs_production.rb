name "ncs_production"
description "Production environment"

default_attributes(
  'postgresql' => {
    'package_version' => '9.1.6-1PGDG.rhel6'
  }
)
