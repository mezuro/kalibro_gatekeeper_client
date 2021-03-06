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

module KalibroGatekeeperClient
  module Entities
    class ReadingGroup < Model

      attr_accessor :id, :name, :description

      def id=(value)
        @id = value.to_i
      end

      def self.all
        # FIXME: for some reason, the JSON is not getting automatically parsed
        create_objects_array_from_hash(JSON.parse(request('all', {}, :get))['reading_groups'])
      end
      
      private

      def self.id_params(id)
        {id: id}
      end
      
      def destroy_params
        {id: self.id}
      end

    end
  end
end