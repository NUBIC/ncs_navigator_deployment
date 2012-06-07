Description
===========

Recipes to install log.io's server and harverster components.

There's two recipes, as you might expect:

* server: installs the server
* harvester: installs the harvester

This cookbook also provides an LWRP for adding log file paths to the
harvester.  Example usage:

    logio_harvester_path "httpd_access_log" do
      action :add
      path "/var/log/httpd/access.log"
    end

    logio_harvester_path "tomcat" do
      action :remove
    end

Neither the harvester nor server recipes switch npm to unsafe mode; therefore,
you will only be able to harvest logs that are world-readable.  Future
versions of this cookbook may have a better solution (e.g. usage of Linux
capabilities, SELinux, AppArmor, ...)

Requirements
============

Written for and tested on CentOS 6.2.

Marius Ducea's nodejs cookbook: https://github.com/mdxp/nodejs-cookbook

This cookbook uses Linux capabilities (specifically, `CAP_DAC_READ_SEARCH`) to
grant a logio user read-only permissions to log files.

Attributes
==========

* `logio[:dir]`: The directory where the log.io harvester or server will be
  installed.  Defaults to `node[:nodejs][:dir]`.
* `logio[:harvester][:user]`: The user for log.io's harvester.  Defaults to `nobody`.
* `logio[:server][:uri]`: The URI of the server to use.  No default.

Usage
=====
