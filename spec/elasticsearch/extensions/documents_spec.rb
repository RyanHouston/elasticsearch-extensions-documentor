require 'spec_helper'
require 'logger'

module Elasticsearch::Extensions
  describe Documents do

    let(:logger) { Logger.new(STDOUT) }
    before do
      Documents.configure do |config|
        config.url        = 'http://example.com:9200'
        config.index_name = 'test_index'
        config.mappings   = { mappings: :here }
        config.settings   = { settings: :here }
        config.logger     = logger
        config.log        = true
      end
    end

    describe '.configuration' do
      subject(:config) { Documents.configuration }

      specify { expect(config.url).to eql 'http://example.com:9200' }
      specify { expect(config.index_name).to eql 'test_index' }
      specify { expect(config.mappings).to eql({ mappings: :here}) }
      specify { expect(config.settings).to eql({ settings: :here}) }
      specify { expect(config.logger).to equal logger }
      specify { expect(config.logger).to be_true }
    end

    describe '.client' do
      subject(:client) { Documents.client }

      it 'creates an instance of Elasticsearch::Transport::Client' do
        expect(client).to be_instance_of Elasticsearch::Transport::Client
      end

      it 'caches the client instance' do
        c1 = Documents.client
        c2 = Documents.client
        expect(c1).to equal c2
      end
    end

    describe '.index_name' do
      specify { expect(Documents.index_name).to eq 'test_index' }
    end

    describe '.logger' do
      specify { expect(Documents.logger).to equal logger }
    end

  end
end

