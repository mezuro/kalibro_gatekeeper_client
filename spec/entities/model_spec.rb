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

require 'spec_helper'

describe KalibroGatekeeperClient::Entities::Model do
  subject { FactoryGirl.build(:model) }

  describe 'new' do
    it 'should create a model from an empty hash' do
      subject = KalibroGatekeeperClient::Entities::Model.new {}
      expect(subject.kalibro_errors).to eq([])
    end
  end

  describe 'class_name' do
    it 'should be a String' do
      expect(subject.class.class_name).to be_a(String)
    end

    it 'should return Model' do
      expect(subject.class.class_name).to eq('Model')
    end
  end

  describe 'endpoint' do
    it 'should return the class_name' do
      endpoint = 'tests'
      KalibroGatekeeperClient::Entities::Model.expects(:class_name).returns(endpoint)
      expect(KalibroGatekeeperClient::Entities::Model.endpoint).to eq(endpoint)
    end
  end

  describe 'client' do
    it 'returns a Faraday::Connection' do
      expect(KalibroGatekeeperClient::Entities::Model.client).to be_a(Faraday::Connection)
    end
  end

  describe 'request' do
    let(:fixture) { File.read("spec/savon/fixtures/project/does_not_exists.xml") }
    let(:client) { mock('client') }
    let(:response) { mock('response') }
    let(:request) { mock('request') }
    let(:options) { mock('options') }

    before :each do
      options.expects(:timeout=)
      options.expects(:open_timeout=)
      request.expects(:url).with('/models/exists')
      request.expects(:body=).with({id: 1})
      request.expects(:options).twice.returns(options)
    end

    context 'for the KalibroGatekeeperClient::Entitie class' do
      it 'should successfully get the Kalibro version' do
        response.expects(:body).returns({exists: false})
        client.expects(:post).
          yields(request).
          returns(response)
        KalibroGatekeeperClient::Entities::Model.
          expects(:client).
          with(any_parameters).
          returns(client)
        expect(KalibroGatekeeperClient::Entities::Model.
          request('exists', {id: 1})[:exists]).to eq(false)
      end
    end

    context 'with a children class from outside' do
      class Child < KalibroGatekeeperClient::Entities::Model; end

      it 'should successfully get the Kalibro version' do
        response.expects(:body).returns({exists: false})
        client.expects(:post).
          yields(request).
          returns(response)
        Child.
          expects(:client).
          with(any_parameters).
          returns(client)
        expect(Child.
          request('exists', {id: 1})[:exists]).to eq(false)
      end
    end
  end

  describe 'to_hash' do
    it 'should return an empty hash' do
      expect(subject.to_hash).to be_empty
    end
  end

  describe 'to_object' do
    it 'should return an Object with an empty hash' do
      expect(KalibroGatekeeperClient::Entities::Model.to_object({})).to eq(FactoryGirl.build(:model))
    end

    it "should remain an object if it isn't a Hash" do
      expect(KalibroGatekeeperClient::Entities::Model.to_object(Object.new)).to be_an(Object)
    end
  end

  describe 'to_objects_array' do
    it 'should convert [{}] to [Model]' do
      expect(KalibroGatekeeperClient::Entities::Model.to_objects_array({})).to eq([FactoryGirl.build(:model)]) 
    end

    it 'should remain an array if it already is one' do
      object = Object.new
      expect(KalibroGatekeeperClient::Entities::Model.to_objects_array([object])).to eq([object]) 
    end
  end

  describe 'save' do
    before :each do
      KalibroGatekeeperClient::Entities::Model.
        expects(:request).
        with('save', {model: {}}).returns({'id' => 42, 'kalibro_errors' => []})
    end

    context "when it doesn't have the method id=" do
      it 'should make a request to save model with id returning false and an error' do
        expect(subject.save).to be(false)
        expect(subject.kalibro_errors[0]).to be_a(NoMethodError)
      end
    end

    context 'when it has the method id=' do
      before :each do
        KalibroGatekeeperClient::Entities::Model.
          any_instance.expects(:id=).
          with(42).
          returns(42)
      end

      it 'should make a request to save model with id and return true without errors' do
        expect(subject.save).to be(true)
        expect(subject.kalibro_errors).to be_empty
      end
    end
  end

  describe 'save!' do
    subject { FactoryGirl.build(:project) }

    it 'should call save' do
      subject.expects(:save)
      subject.save!
    end
  end

  describe 'create' do
    before :each do
      subject.expects(:save)
      KalibroGatekeeperClient::Entities::Model.
        expects(:new).
        with({}).
        returns(subject)
    end

    it 'should instantiate and save the model' do
      expect(KalibroGatekeeperClient::Entities::Model.create {}).to eq(subject)
    end
  end

  describe '==' do
    context 'comparing objects from different classes' do
      it 'should return false' do
        expect(subject).not_to eq(Object.new)
      end
    end

    context 'with two models with different attribute values' do
      let(:another_model) { FactoryGirl.build(:model) }
      before :each do
        subject.expects(:variable_names).returns(["answer"])
        subject.expects(:send).with("answer").returns(42)
        another_model.expects(:send).with("answer").returns(41)
      end 

      it 'should return false' do
        expect(subject).not_to eq(another_model)
      end
    end

    context 'with two empty models' do
      it 'should return true' do
        expect(subject).to eq(FactoryGirl.build(:model))
      end
    end
  end

  describe 'exists?' do
    context 'with an inexistent id' do
      before :each do
        KalibroGatekeeperClient::Entities::Model.
          expects(:request).
          with('exists', {id: 0}).
          returns({'exists' => false})
      end

      it 'should return false' do
        expect(KalibroGatekeeperClient::Entities::Model.exists?(0)).to eq(false)
      end
    end

    context 'with an existent id' do
      before :each do
        KalibroGatekeeperClient::Entities::Model.
          expects(:request).
          with('exists', {id: 42}).
          returns({'exists' => true})
      end

      it 'should return false' do
        expect(KalibroGatekeeperClient::Entities::Model.exists?(42)).to eq(true)
      end
    end
  end

  describe 'find' do
    context 'with an inexistent id' do
      before :each do
        KalibroGatekeeperClient::Entities::Model.expects(:exists?).with(0).returns(false)
      end

      it 'should raise a RecordNotFound error' do
        expect { KalibroGatekeeperClient::Entities::Model.find(0)}.to raise_error(KalibroGatekeeperClient::Errors::RecordNotFound)
      end
    end

    context 'with an existent id' do
      before :each do
        KalibroGatekeeperClient::Entities::Model.
          expects(:exists?).with(42).
          returns(true)
        KalibroGatekeeperClient::Entities::Model.
          expects(:request).
          with('get',{id: 42}).returns({})
      end

      it 'should return an empty model' do
        expect(KalibroGatekeeperClient::Entities::Model.find(42)).to eq(subject)
      end
    end
  end

  describe 'destroy' do
    context 'when it gets successfully destroyed' do
      before :each do
        subject.expects(:id).at_least_once.returns(42)
        KalibroGatekeeperClient::Entities::Model.
          expects(:request).
          with('destroy',{id: subject.id})
      end

      it 'should remain with the errors array empty' do
        subject.destroy
        expect(subject.kalibro_errors).to be_empty
      end
    end

    context 'when the destruction fails' do
      before :each do
        subject.expects(:id).at_least_once.returns(42)
        KalibroGatekeeperClient::Entities::Model.
          expects(:request).
          with('destroy',{id: subject.id}).raises(Exception.new)
      end

      it "should have an exception inside it's errors" do
        subject.destroy

        expect(subject.kalibro_errors[0]).to be_an(Exception)
      end
    end
  end

  describe 'create_objects_array_from_hash' do
    context 'with nil' do
      it 'should return an empty array' do
        expect(KalibroGatekeeperClient::Entities::Model.create_objects_array_from_hash(nil)).to eq([])
      end
    end

    context 'with a Hash' do
      it 'should return the correspondent object to the given hash inside of an Array' do
        expect(KalibroGatekeeperClient::Entities::Model.create_objects_array_from_hash({})).to eq([subject])
      end
    end
  end

  describe 'is_valid?' do
    context 'with a global var' do
      it 'should return false' do
        expect(KalibroGatekeeperClient::Entities::Model.is_valid?('@test')).to be_falsey
      end
    end

    context 'with the attributes var' do
      it 'should return false' do
        expect(KalibroGatekeeperClient::Entities::Model.is_valid?(:attributes!)).to be_falsey
      end
    end

    context 'with a xsi var' do
      it 'should return false' do
        expect(KalibroGatekeeperClient::Entities::Model.is_valid?('test_xsi')).to be_falsey
      end
    end

    context 'with a valid var' do
      it 'should return true' do
        expect(KalibroGatekeeperClient::Entities::Model.is_valid?('test')).to be_truthy
      end
    end
  end
end