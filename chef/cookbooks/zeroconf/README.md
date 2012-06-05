Description
===========

Activates Zeroconf via Avahi.

Useful if you need to be able to address a node by name (i.e. for an SSL
certificate).

The default recipe:

1. installs avahi and nss-mdns
2. modifies nsswitch.conf to use the mdns resolver
3. adds messagebus and avahi-daemon to the default runlevel
4. permits traffic on UDP port 5353 (Zeroconf standard port)

Requirements
============

Written for and tested on CentOS 6.2.  The EPEL repository must be active; at
present, nss-mdns does not exist in CentOS 6's package repository.

This cookbook depends on the iptables cookbook for its iptables_rule definition.

Attributes
==========

None.

Usage
=====

Plug it in to your run list and go.

This is recommended for use only in development environments.
