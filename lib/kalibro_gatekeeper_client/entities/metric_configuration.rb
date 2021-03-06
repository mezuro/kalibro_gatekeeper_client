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
    class MetricConfiguration < Model

      attr_accessor :id, :code, :metric, :metric_collector_name, :weight, :aggregation_form, :reading_group_id, :configuration_id

      def id=(value)
        @id = value.to_i
      end

      def reading_group_id=(value)
        @reading_group_id = value.to_i
      end

      def metric=(value)
        @metric = KalibroGatekeeperClient::Entities::Metric.to_object(value)
      end

      def weight=(value)
        @weight = value.to_f
      end

      def update_attributes(attributes={})
        attributes.each { |field, value| send("#{field}=", value) if self.class.is_valid?(field) }
        save
      end

      def to_hash
        super :except => [:configuration_id]
      end

      def self.metric_configurations_of(configuration_id)
        create_objects_array_from_hash request(:of, {:configuration_id => configuration_id})['metric_configurations']
      end

      def self.find(id)
        #TODO: on future versions of Kalibro this begin/rescue will be unnecessary
        metric_configuration = request(:get, {id: id})
        raise KalibroGatekeeperClient::Errors::RecordNotFound unless metric_configuration['error'].nil?
        return new(metric_configuration)
      end

      def self.exists?(id)
        begin
          return true unless find(id).nil?
        rescue KalibroGatekeeperClient::Errors::RecordNotFound
          return false
        end
      end

      private

      def save_params
        {:metric_configuration => self.to_hash, :configuration_id => self.configuration_id}
      end
    end
  end
end
