#
# Cookbook Name:: tomcat
# Recipe:: custom_trust_store
#
# Copyright 2012, Northwestern University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Note: you MUST import at least one key or certificate into the Tomcat
# keystore for this recipe to produce a valid configuration.  This recipe
# does not create an empty keystore because keytool doesn't provide any way
# to do that.

include_recipe "java"
include_recipe "openssl"

# Generate a keystore password for applications running in Tomcat.
# This is not the same keystore set up in Tomcat connectors.  That keystore
# is used to *provide* HTTPS connections to clients; this keystore is used to
# *verify* HTTPS connections established by applications in Tomcat.
extend Opscode::OpenSSL::Password

unless node["tomcat"]["keystore"]["password"]
  keystore_password = secure_password
  node["tomcat"]["keystore"]["password"] = keystore_password
  node.save unless Chef::Config[:solo]
end

trust_store = node["tomcat"]["keystore"]["path"]
trust_store_password = node["tomcat"]["keystore"]["password"]

tomcat_property "set_tomcat_trust_store" do
  properties %W(
    javax.net.ssl.trustStore=#{trust_store}
    javax.net.ssl.trustStorePassword=#{trust_store_password}
  )
end
