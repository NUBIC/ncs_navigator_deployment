maintainer       "Northwestern University"
maintainer_email "yipdw@northwestern.edu"
license          "Apache 2.0"
description      "Installs/Configures passenger"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe           "apache2-rvm", "Installs Passenger using Apache2 + RVM"

attribute "passenger/rvm_ruby_string",
  :display_name => "RVM Ruby string",
  :description => "RVM Ruby string for Passenger's Ruby",
  :type => "string",
  :default => "",
  :recipes => ["apache2-rvm"]
