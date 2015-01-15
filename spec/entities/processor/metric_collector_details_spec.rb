# This file is part of KalibroClient
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

require 'spec_helper'

describe KalibroClient::Entities::Processor::MetricCollectorDetails do
  describe 'all_names' do
    context 'with no metric collector details' do
      before :each do
        KalibroClient::Entities::Processor::MetricCollectorDetails.
          expects(:request).
          with(:names, {}, :get).
          returns({'names' => nil}.to_json)
      end

      it 'should return empty array' do
        expect(KalibroClient::Entities::Processor::MetricCollectorDetails.all_names).to be_empty
      end
    end

    context 'with many metric collector details' do
      let(:metric_collector_details_hash) { FactoryGirl.build(:metric_collector_details).to_hash }
      let(:another_metric_collector_details_hash) { FactoryGirl.build(:another_metric_collector_details).to_hash }

      before :each do
        KalibroClient::Entities::Processor::MetricCollectorDetails.
          expects(:request).
          with(:names, {}, :get).
          returns({'metric_collector_names' => [metric_collector_details_hash[:name], another_metric_collector_details_hash[:name]]})
      end

      it 'should return the two elements' do
        names = KalibroClient::Entities::Processor::MetricCollectorDetails.all_names

        expect(names.size).to eq(2)
        expect(names.first).to eq(metric_collector_details_hash[:name])
        expect(names.last).to eq(another_metric_collector_details_hash[:name])
      end
    end
  end

  describe 'all' do
    context 'with no metric collector details' do
      before :each do
        KalibroClient::Entities::Processor::MetricCollectorDetails.
          expects(:request).
          with('', {}, :get).
          returns({"metric_collector_details" => nil})
      end

      it 'should return empty array' do
        expect(KalibroClient::Entities::Processor::MetricCollectorDetails.all).to be_empty
      end
    end

    context 'with many metric collector details' do
      let!(:metric_collector_details_hash) { FactoryGirl.attributes_for(:metric_collector_details) }
      let!(:another_metric_collector_details_hash) { FactoryGirl.attributes_for(:another_metric_collector_details) }

      before :each do
        KalibroClient::Entities::Processor::MetricCollectorDetails.
          expects(:request).
          with('', {}, :get).
          returns({"metric_collector_details" => [metric_collector_details_hash, another_metric_collector_details_hash]})
      end

      it 'should return the two elements' do
        metric_collector_details = KalibroClient::Entities::Processor::MetricCollectorDetails.all

        expect(metric_collector_details.size).to eq(2)
        expect(metric_collector_details.first.name).to eq(metric_collector_details_hash[:name])
        expect(metric_collector_details.last.name).to eq(another_metric_collector_details_hash[:name])
      end
    end
  end

  describe 'find_by_name' do
    subject { FactoryGirl.build(:metric_collector_details) }

    context 'with an inexistent name' do
      before :each do
        KalibroClient::Entities::Processor::MetricCollectorDetails.
          expects(:request).
          with(:find, {name: subject.name}).
          returns(nil)
      end

      it 'should raise a RecordNotFound error' do
        expect { KalibroClient::Entities::Processor::MetricCollectorDetails.find_by_name(subject.name)}.
          to raise_error(KalibroClient::Errors::RecordNotFound)
      end
    end

    context 'with an existent name' do
      before :each do
        KalibroClient::Entities::Processor::MetricCollectorDetails.
          expects(:request).
          with(:find,{name: subject.name}).
          returns({"metric_collector_details" => subject.to_hash({except: [:supported_metrics]})})
      end

      it 'should return a metric_collector_details' do
        expect(KalibroClient::Entities::Processor::MetricCollectorDetails.find_by_name(subject.name).name).to eq(subject.name)
      end
    end
  end

  describe 'Supported Metrics' do
    let(:code_and_metric) { { "total_abstract_classes" => FactoryGirl.build(:metric) } }
    #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with sybols and integers
    let(:code_and_metric_parameter) { { "total_abstract_classes" => Hash[FactoryGirl.attributes_for(:metric)] } }

    context 'supported_metrics acessors' do
      it 'should set the value of the array of supported metrics' do
        subject.supported_metrics = code_and_metric_parameter
        expect(subject.supported_metrics["total_abstract_classes"].to_hash).to eql(code_and_metric["total_abstract_classes"].to_hash)
      end
    end
  end

  describe 'metric' do
    subject { FactoryGirl.build(:metric_collector_details) }
    let(:metric) { subject.supported_metrics["loc"] }

    it 'should return nil with an inexistent name' do
      expect(subject.metric("fake name")).to be_nil
    end

    it 'should return a metric with an existent name' do
      expect(subject.metric(metric.name).name).to eq(metric.name)
    end
  end
end
