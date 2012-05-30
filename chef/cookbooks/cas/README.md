Description 
===========

Installs and configures the Jasig CAS server.  Also applies a NUBIC-developed overlay that

1. uses Bcsec (Aker's predecessor) for authentication, and
2. tracks CAS activity across applications using the same CAS server.

This cookbook includes two recipes:

1. `database`: sets up a database and database user account for the CAS server
2. `tomcat-apache`: installs the CAS server into Tomcat 6, and configures an
   Apache 2 server to proxy to the Tomcat instance

Requirements
============

- A version of PostgreSQL that supports recursive common table subexpressions.
  8.4 is the minimum version; 9.0 is preferred.
- The `database` and `bcdatabase` cookbooks.
- The `aker` cookbook.
- The `openssl` cookbook for password generation.

Attributes
==========

* `aker[:authorities]`: The list of authorities to use.  Defaults to [].  Note:
  with the default configuration, the CAS server will not accept any
  credentials.
* `aker[:central]`: Path to an Aker central configuration file.
* `cas[:log_file]`: Path to a log file.  Defaults to /var/log/cas/nubic-cas.log.
* `cas[:database][:name]`: Name of the CAS database.  Defaults to "nubic_cas".
* `cas[:database][:user]`: The user for the CAS database.  Defaults to "nubic_cas".
* `cas[:database][:bcdatabase][:group]`: The bcdatabase group to use.  Defaults
  to "local_postgresql".

Usage
=====

Include the cas::tomcat-apache recipe in your run list.
