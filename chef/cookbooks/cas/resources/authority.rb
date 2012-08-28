#
# Cookbook Name:: cas
# LWRP:: authority
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

# The send_notification action is internal to this LWRP.
actions :create, :delete, :send_notification

attribute :authority, :kind_of => Symbol
attribute :configuration, :kind_of => String
attribute :static_file, :kind_of => String, :default => nil
