require 'spec_helper'

module Elasticsearch
  module Extensions
    module Documents
      class TestDocument < Document
        indexes_as_type :test_doc
        def as_hash
          { valueA: :a, valueB: :b }
        end
      end

      describe Index do
        let(:client) { double(:client) }
        let(:model) { double(:model, id: 1) }
        let(:document) { TestDocument.new(model) }
        subject(:index) { Index.new(client) }

        describe '#index' do
          it 'adds or replaces a document in the search index' do
            payload = {
              index: 'test_index',
              type: 'test_doc',
              id: 1,
              body: {valueA: :a, valueB: :b}
            }
            expect(client).to receive(:index).with(payload)
            index.index document
          end
        end

        describe '#delete' do
          it 'removes a document from the search index' do
            payload = {
              index: 'test_index',
              type: 'test_doc',
              id: 1,
            }
            expect(client).to receive(:delete).with(payload)
            index.delete document
          end
        end

        describe '#search' do
          let(:query_params) do
            { }
          end
          let(:query) { double(:query, as_hash: query_params) }

          it 'passes on the query request body to the client' do
            expect(client).to receive(:search).with(query_params)
            index.search query
          end

          pending 'returns a Results object' do
            index.search(query).should be_kind_of Results
          end
        end

        describe '#refresh' do
          it 'delegates to the client#indices' do
            indices = double(:indices, refresh: true)
            client.stub(:indices).and_return(indices)
            expect(indices).to receive(:refresh).with(index: 'test_index')
            index.refresh
          end
        end

      end
    end
  end
end
