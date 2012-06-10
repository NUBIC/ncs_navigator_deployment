Description 
===========

Installs and configures the Jasig CAS server.  Also applies a NUBIC-developed
overlay that

1. uses the NetID authority of Bcsec (Aker's predecessor) for authentication
2. tracks CAS activity across applications using the same CAS server.

This cookbook includes the following recipes:

1. `database`: sets up a database and database user account for the CAS server
2. `server`: installs the CAS server into Tomcat 6
3. `callback`: sets up CAS proxy callbacks for Passenger
4. `apache`: exposes CAS components over HTTPS via Apache
5. `monitoring`: installs Monit configuration for CAS
6. `default`: runs 1-5

Requirements
============

- A version of PostgreSQL that supports recursive common table subexpressions.
  8.4 is the minimum version; 9.0 is preferred.
- The `database` and `bcdatabase` cookbooks.
- The `aker` cookbook.
- The `ssl_certificates` cookbook.
- The `openssl` cookbook for password generation.

The apache recipe assumes that the CAS server and proxy callbacks are
accessible via the same IP address.

Attributes
==========

NetID
-----

* `netid[:user]`: A DN describing the user to log into NU's NetID directory.
  Defaults to "".
* `netid[:password]`: Password for that user.  Defaults to "".

Server
------

* `cas[:log]`: Path to the CAS server's log file.  Defaults to
  /var/log/cas/nubic-cas.log.
* `cas[:dir]`: Path to the CAS server's configuration directory.  Defaults to
  /etc/nubic/cas-server.
* `cas[:bcsec]`: Path to the Aker configuration file for the CAS server.
  Defaults to #{cas[:dir]}/bcsec.rb.
* `cas[:script_name]`: The script name of the CAS server.  Defaults to the path
  of `node[:cas][:base_url]`; unspecified otherwise.

Database
--------
* `cas[:database][:name]`: Name of the CAS database.  Defaults to "nubic_cas".
* `cas[:database][:user]`: The user for the CAS database.  Defaults to "nubic_cas".
* `cas[:database][:bcdatabase][:group]`: The bcdatabase group to use.  Defaults
  to "local_postgresql".

Apache
------
* `cas[:apache][:document_root]`: The document root for Apache integration.
  Defaults to `/var/www`.
* `cas[:apache][:ssl_certificate]`: The SSL certificate to use.  No default.
* `cas[:apache][:ssl_certificate_key]`: The SSL certificate key to use.  No
  default.

Callbacks
---------
* `cas[:callback][:script_name]`: The script name of the CAS proxy callbacks.
  Defaults to the first component of the path in
  `node[:cas][:proxy_callback_url]`; unspecified otherwise.
* `cas[:callback][:user]`: The user that will run the proxy callback.  Defaults
  to "cas".
* `cas[:callback][:app_path]`: The application path for the CAS proxy callback.
  Defaults to `#{node[:cas][:apache][:document_root]}/apps/cas_proxy_callback`.

Usage
=====

At NUBIC, we dedicate one VM to running CAS, so we just use the default recipe.
YMMV.
