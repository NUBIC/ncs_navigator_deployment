#
# Cookbook Name:: postgresql
# Resource:: hba
#
# Copyright 2013, Northwestern University
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

actions :create, :delete, :rebuild, :send_notification

attribute :cidr_address, :kind_of => String
attribute :database, :kind_of => String, :required => true
attribute :method, :kind_of => String
attribute :options, :kind_of => Hash, :default => {}
attribute :type, :kind_of => String, :equal_to => ['local', 'host', 'hostssl', 'hostnossl'], :required => true
attribute :user, :kind_of => String, :required => true
