#
# Cookbook Name:: bcdatabase
# Library:: Chef::Bcdatabase::GroupHelpers
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

require 'yaml'

class Chef
  module Bcdatabase
    module GroupHelpers
      ##
      # Returns true if a bcdatabase group is present on the system, false
      # otherwise.
      def group_present?(group_name)
        ::File.exists?(filename_for_group(group_name))
      end

      ##
      # Returns the contents of a group as a Ruby hash, or {} if the group
      # does not exist.
      def configs_in(group_name)
        if group_present?(group_name)
          fn = filename_for_group(group_name)

          YAML.load(File.read(fn))
        else
          {}
        end
      end

      ##
      # Builds the filename of a bcdatabase group.
      def filename_for_group(group_name)
        conf_dir = node[:bcdatabase][:directory]

        "#{conf_dir}/#{group_name}.yml"
      end
    end
  end
end
