Description
===========

Recipes:

* `web`: Exposes NCS Navigator applications via a Web server.
* `devenv`: Configures NCS Navigator applications for development.

Requirements
============

Cookbook dependencies:

* `apache2`
* `tomcat`
* `build-essential` (for `devenv`)
* `ssl_certificates`

The web recipe currently only works with Apache, Passenger, and Tomcat.

The `devenv` recipe can only be used in the `ncs_development` environment, and
will raise an error if run in a different environment.

Attributes
==========

These attributes MUST be set:

* `ncs_navigator[:core][:ssl][:certificate]`: The path to the SSL certificate
  used by NCS Navigator Core.
* `ncs_navigator[:core][:ssl][:key]`: The path to the SSL private key used by
  NCS Navigator Core.
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
