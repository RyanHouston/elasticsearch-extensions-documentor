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
        let(:adapter) { double(:adapter) }
        let(:model) { double(:model, id: 1) }
        let(:document) { TestDocument.new(model) }
        subject(:index) { Index.new(adapter) }

        describe '#index' do
          it 'adds or replaces a document in the search index' do
            payload = {
              type: 'test_doc',
              id: 1,
              body: {valueA: :a, valueB: :b}
            }
            expect(adapter).to receive(:index).with(payload)
            index.index document
          end
        end

        describe '#delete' do
          it 'removes a document from the search index' do
            payload = {
              type: 'test_doc',
              id: 1,
            }
            expect(adapter).to receive(:delete).with(payload)
            index.delete document
          end
        end

        describe '#search' do
          let(:query_params) do
            {
              query: {
                query_string: "search term",
                analyzer:     "snowball",
              }
            }
          end

          let(:response) do
            {
              "hits" => {
                "total" => 4000,
                "max_score" => 4.222,
                "hits" => [
                  {
                    "_type"  => "user",
                    "_id"    => 42,
                    "_score" => 4.222,
                    "_source" => { "name" => "Joe" }
                  }
                ],
              }
            }
          end

          let(:query) { double(:query, as_hash: query_params) }

          it 'passes on the query request body to the adapter' do
            expect(adapter).to receive(:search).with(query_params)
            index.search query
          end

          it 'returns a Hashie::Mash instance' do
            adapter.stub(:search).and_return(response)
            response = index.search(query)
            response.should be_kind_of Hashie::Mash
          end
        end

        describe '#refresh' do
          it 'delegates to the adapter' do
            expect(adapter).to receive(:refresh)
            index.refresh
          end
        end

      end
    end
  end
end
