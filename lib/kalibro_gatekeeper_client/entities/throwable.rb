# This file is part of KalibroGatekeeperClient
# Copyright (C) 2013  it's respectives authors (please see the AUTHORS file)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require "kalibro_gatekeeper_client/entities/model"

module KalibroGatekeeperClient
  module Entities
    class Throwable < Model
      
      attr_accessor :target_string, :message, :cause, :stack_trace_element

      def stack_trace_element=(value)
        @stack_trace_element = KalibroGatekeeperClient::Entities::StackTraceElement.to_objects_array value
      end

      def stack_trace
        @stack_trace_element
      end

      def stack_trace=(stack_trace)
        @stack_trace_element = stack_trace
      end

      def cause=(cause_value)
        @cause = KalibroGatekeeperClient::Entities::Throwable.to_object cause_value
      end
    end
  end
end