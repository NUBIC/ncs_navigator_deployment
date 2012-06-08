Description
===========

Recipes:

* web: Exposes NCS Navigator applications via a Web server.

Requirements
============

Cookbook dependencies:

* apache2

The web recipe currently only works with Apache.

Attributes
==========

These attributes MUST be set:

* `ncs_navigator[:core][:url]`: The URL of NCS Navigator Core.
* `ncs_navigator[:psc][:url]`: The URL of Patient Study Calendar.
* `ncs_navigator[:staff_portal][:url]`: The URL of NCS Staff Portal.

Usage
=====
