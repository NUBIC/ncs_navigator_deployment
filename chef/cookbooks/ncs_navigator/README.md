Description
===========

Recipes:

* `app`: Sets up an application server for NCS Navigator.
* `db_server`: Sets up a database server for NCS Navigator.
* `devenv`: Configures an NCS Navigator application server for development.

There are other recipes in this cookbook; however, they're intended to be used
by the recipes listed above.  Use those private recipes at your own risk.

Requirements
============

Cookbook dependencies:

* `apache2`
* `tomcat`
* `bcdatabase`
* `build-essential` (for `devenv`)
* `ssl_certificates`

The web recipe currently only works with Apache, Passenger, and Tomcat.

The `devenv` recipe can only be used in the `ncs_development` environment, and
will raise an error if run in a different environment.

Attributes
==========

Unless a default is specified, all attributes in this list do NOT have a
default.

SSL
---
* `ncs_navigator[:core][:ssl][:certificate]`: The path to the SSL certificate
  used by NCS Navigator Core.
* `ncs_navigator[:core][:ssl][:key]`: The path to the SSL private key used by
  NCS Navigator Core.

URLs
----
* `ncs_navigator[:core][:url]`: The URL of NCS Navigator Core.
* `ncs_navigator[:psc][:ssl][:certificate]`: The path to the SSL certificate
  used by Patient Study Calendar.
* `ncs_navigator[:psc][:ssl][:key]`: The path to the SSL private key used by
  Patient Study Calendar.
* `ncs_navigator[:psc][:url]`: The URL of Patient Study Calendar.
* `ncs_navigator[:staff_portal][:ssl][:certificate]`: The path to the SSL
  certificate used by NCS Staff Portal.
* `ncs_navigator[:staff_portal][:ssl][:key]`: The path to the SSL private key
  used by NCS Staff Portal.
* `ncs_navigator[:staff_portal][:url]`: The URL of NCS Staff Portal.
* `ncs_navigator[:cas][:base_url]`: The base URL of the CAS server to use.
* `ncs_navigator[:cas][:proxy_callback_url]`: The URL of the PGT repository to use.
* `ncs_navigator[:cas][:proxy_retrieval_url]`: The URL of the PGT retrieval
  service to use.

Database
--------
* `ncs_navigator[:core][:database][:bcdatabase_group]`: The bcdatabase group for NCS
  Navigator Core.  Defaults to `ncsdb_prod`.
* `ncs_navigator[:staff_portal][:database][:bcdatabase_group]`: The bcdatabase group for
  NCS Staff Portal.  Defaults to `ncsdb_prod`.
* `ncs_navigator[:core][:database][:host]`: The host running the database for
  NCS Navigator Core.  This SHOULD be an FQDN known to Chef.
* `ncs_navigator[:psc][:database][:host]`: The host running the database for
  Patient Study Calendar.  This SHOULD be an FQDN known to Chef.
* `ncs_navigator[:staff_portal][:database][:host]`: The host running the
  database for NCS Staff Portal.  This SHOULD be an FQDN known to Chef.
* `ncs_navigator[:core][:database][:username]`: The database username for NCS
  Navigator Core.  Defaults to `ncs_navigator_core`.
* `ncs_navigator[:core][:database][:name]`: The name of the database to use for
  NCS Navigator Core.  Defaults to `ncs_navigator_core`.
* `ncs_navigator[:psc][:database][:name]`: The name of the database to use for
  Patient Study Calendar.  Defaults to `psc`.
* `ncs_navigator[:staff_portal][:database][:name]`: The name of the database to use for
  NCS Staff Portal.  Defaults to `ncs_staff_portal`.
* `ncs_navigator[:psc][:database][:username]`: The database username for
  Patient Study Calendar.  Defaults to `psc`.
* `ncs_navigator[:staff_portal][:database][:username]`: The database username
  for NCS Staff Portal.  Defaults to `ncs_staff_portal`.
* `ncs_navigator[:core][:database][:password]`: The database password for NCS
  Navigator Core.
* `ncs_navigator[:psc][:database][:password]`: The database password for
  Patient Study Calendar.
* `ncs_navigator[:staff_portal][:database][:password]`: The database password
  for NCS Staff Portal.

The `devenv` recipe sets these attributes as follows:

CERT_PATH: /etc/pki/tls/certs
KEY_PATH: /etc/pki/tls/private
HOSTNAME: the hostname (not FQDN) of the node

| `ncs_navigator[:core][:ssl][:certificate]`         | CERT_PATH/navigator.HOSTNAME.local.crt   |
| `ncs_navigator[:core][:ssl][:key]`                 | KEY_PATH/navigator.HOSTNAME.local.key    |
| `ncs_navigator[:core][:url]`                       | https://navigator.HOSTNAME.local         |
| `ncs_navigator[:psc][:ssl][:certificate]`          | CERT_PATH/navcal.HOSTNAME.local.crt      |
| `ncs_navigator[:psc][:ssl][:key]`                  | KEY_PATH/navcal.HOSTNAME.local.key       |
| `ncs_navigator[:psc][:url]`                        | https://navcal.HOSTNAME.local            |
| `ncs_navigator[:staff_portal][:ssl][:certificate]` | CERT_PATH/staffportal.HOSTNAME.local.crt |
| `ncs_navigator[:staff_portal][:ssl][:key]`         | KEY_PATH/staffportal.HOSTNAME.local.key  |
| `ncs_navigator[:staff_portal][:url]`               | https://staffportal.HOSTNAME.local       |

Usage
=====
