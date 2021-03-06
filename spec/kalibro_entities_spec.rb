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

describe KalibroGatekeeperClient do

  context 'configuration' do
    #FIXME: there should be a better way to keep the default values
    let(:config) {{address: "http://localhost:8081"}}

    describe 'config' do
      it 'should return the default configuration' do
        expect(KalibroGatekeeperClient.config).to eq({
                                          address: "http://localhost:8081"
                                        })
      end
    end

    describe 'configure' do
      after(:each) {KalibroGatekeeperClient.configure(config)}

      it 'should set the address' do
        KalibroGatekeeperClient.configure({address: 'http://test.test'})
        expect(KalibroGatekeeperClient.config).to eq({address: 'http://test.test'})
      end
    end

    describe 'configure_with' do
      context 'with an existent YAML' do
        after(:each) {KalibroGatekeeperClient.configure(config)}

        it 'should set the config' do
          KalibroGatekeeperClient.configure_with('spec/savon/fixtures/config.yml')

          expect(KalibroGatekeeperClient.config).to eq({address: 'http://test1.test1'})
        end
      end

      context 'with an inexistent YAML' do
        before :each do
          @logger = Logger.new(File::NULL)
          KalibroGatekeeperClient.expects(:logger).returns(@logger)
        end

        it 'should keep the defaults' do
          KalibroGatekeeperClient.configure_with('spec/savon/fixtures/inexistent_file.yml')
          expect(KalibroGatekeeperClient.config).to eq({address: "http://localhost:8081"})
        end

        it 'should log an warning' do
          @logger.expects(:warn).with("YAML configuration file couldn't be found. Using defaults.")

          KalibroGatekeeperClient.configure_with('spec/savon/fixtures/inexistent_file.yml')
        end
      end

      context 'with an invalid YAML' do
        before :each do
          @logger = Logger.new(File::NULL)
          KalibroGatekeeperClient.expects(:logger).returns(@logger)
        end

        it 'should keep the defaults' do
          KalibroGatekeeperClient.configure_with('spec/savon/fixtures/invalid_config.yml')
          expect(KalibroGatekeeperClient.config).to eq({address: "http://localhost:8081"})
        end

        it 'should log an warning' do
          @logger.expects(:warn).with("YAML configuration file contains invalid syntax. Using defaults.")

          KalibroGatekeeperClient.configure_with('spec/savon/fixtures/invalid_config.yml')
        end
      end
    end
  end

  context 'Logger' do
    describe 'logger' do
      it 'should return the default logger' do
        expect(KalibroGatekeeperClient.logger).to be_a(Logger)
      end
    end

    describe 'logger=' do
      it 'should set the logger' do
        logger = Logger.new(STDOUT)

        KalibroGatekeeperClient.logger = logger

        expect(KalibroGatekeeperClient.logger).to eq(logger)
      end
    end
  end
end