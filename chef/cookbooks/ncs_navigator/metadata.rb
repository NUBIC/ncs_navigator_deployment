maintainer       "Northwestern University"
maintainer_email "YOUR_EMAIL"
license          "Apache 2.0"
description      "Installs/Configures ncs_navigator"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "apache2"
depends "application_user"
depends "bcdatabase"
depends "database"
depends "postgresql"
depends "tomcat"
