require 'spec_helper'
require 'logger'

module Elasticsearch::Extensions
  describe Documents do

    describe '.configuration' do
      subject(:config) { Documents.configuration }

      specify { expect(config.url).to eql 'http://example.com:9200' }
      specify { expect(config.index_name).to eql 'test_index' }
      specify { expect(config.mappings).to eql( :fake_mappings ) }
      specify { expect(config.settings).to eql( :fake_settings ) }
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

