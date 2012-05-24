Description
===========

Installs Passenger into Apache2, using a Ruby environment managed by a
system-level RVM.

Requirements
============

* fnichol/chef-rvm
* apache2

Attributes
==========

* passenger[:rvm_ruby_string]: The RVM Ruby string to be used by Passenger.
  This MUST be set; there is no default.
* passenger[:version]: The version of Passenger to install.
  The default is "3.0.12".
  This MUST address exactly one version of Passenger; version ranges are
  not permitted.

Usage
=====

Include the apache2-rvm recipe in your run list.  The apache2 and rvm recipes
MUST be in the run list before it.
