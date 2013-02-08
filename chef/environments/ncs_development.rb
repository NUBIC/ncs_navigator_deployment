name "ncs_development"
description "Development environment"

override_attributes(
  :development => true,
  'postgresql' => {
    'package_version' => '9.1.8-1PGDG.rhel6'
  }
)
