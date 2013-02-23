#
# Cookbook Name:: ncs_navigator
# Library:: persistent_generated_attribute
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

module NcsNavigator
  module PersistentGeneratedAttribute
    # Here are some Chef resolution-time games.
    #
    # If the value file doesn't exist at resource resolution time, this method
    # yields to a value generator, and said value will be persisted.  If the
    # value file does exist at resource resolution time, you'll get the
    # previously generated value.
    def find_or_generate(path)
      value = File.exists?(path) ? File.read(path) : yield

      value.tap do
        directory File.dirname(path) do
          recursive true
          action :create
        end

        file path do
          action :create_if_missing
          content value
          mode 0400
        end
      end
    end
  end
end
