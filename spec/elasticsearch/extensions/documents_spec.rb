require 'spec_helper'
require 'logger'

module Elasticsearch::Extensions
  describe Documents do

    describe '.configuration' do
      subject(:config) { Documents.configuration }

      its(:index_name) { should eql 'test_index' }
      its(:mappings) { should eql :fake_mappings  }
      its(:settings) { should eql :fake_settings  }
    end

    describe '.client' do
      subject(:client) { Documents.client }

      it 'creates an instance of Elasticsearch::Transport::Client' do
        expect(client).to be_instance_of Elasticsearch::Transport::Client
      end

      it 'provides a new client instance for each call' do
        c1 = Documents.client
        c2 = Documents.client
        expect(c1).not_to equal c2
      end

      it 'instantiates the client with the config.client settings' do
        Documents.configure do |config|
          config.client.url = 'http://example.com:9200/es'
          config.client.logger = :app_logger
          config.client.tracer = :app_tracer
        end

        expect(Elasticsearch::Client).to receive(:new) do |options|
          expect(options[:url]).to eq 'http://example.com:9200/es'
          expect(options[:logger]).to eq :app_logger
          expect(options[:tracer]).to eq :app_tracer
        end
        Documents.client
      end
    end

    describe '.index_name' do
      specify { expect(Documents.index_name).to eq 'test_index' }
    end

    describe '.logger' do
      it 'provides a default logger if none is given' do
        expect(Documents.logger).to be_kind_of Logger
      end
    end

  end
end

