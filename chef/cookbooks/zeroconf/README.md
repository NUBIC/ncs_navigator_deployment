Description
===========

Activates Zeroconf via Avahi.  Also contains a recipe for installing files for
developing custom code on top of avahi for e.g. publishing CNAMEs of hosts.

Useful if you need to be able to address a node by name (i.e. for an SSL
certificate).

The default recipe:

1. installs avahi and nss-mdns
2. modifies nsswitch.conf to use the mdns resolver
3. adds messagebus and avahi-daemon to the default runlevel
4. permits traffic on UDP port 5353 (Zeroconf standard port)

The devel recipe:

1. includes the default recipe
2. installs avahi-devel

The cnames recipe:

1. installs the devel recipe
2. installs build tools
3. builds and installs a tool to publish CNAMEs over Zeroconf

Requirements
============

Written for and tested on CentOS 6.2.  The EPEL repository must be active; at
present, nss-mdns does not exist in CentOS 6's package repository.

This cookbook depends on the iptables cookbook for its iptables_rule definition.

Attributes
==========

* `zeroconf[:allowed_interfaces]`: A list of interfaces that avahi-daemon
  should use.  Defaults to the empty list, which means that avahi-daemon will
  use all non-loopback and non-point-to-point interfaces.
* `zeroconf["cnames"]`: CNAME records to publish for the host.  Only used with
  zeroconf::cnames.  Defaults to [].

Usage
=====

Plug it in to your run list and go.

This is recommended for use only in development environments.
