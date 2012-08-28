#
# Cookbook Name:: cas
# LWRP:: bcsec_configuration
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

# The rebuild action is intended to be used only by cas_* resources.  If you
# run this action from outside that context, you're on your own.
actions :create, :rebuild

attribute :file_mode, :kind_of => Integer
attribute :file_owner, :kind_of => String
