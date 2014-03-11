require 'spec_helper'
require 'elasticsearch/extensions/documents/queryable'

module Elasticsearch
  module Extensions
    module Documents
      describe Queryable do

        context 'when a subclass is not correctly implemented' do
          class InvalidQuery
            include Queryable
          end

          subject(:query) { InvalidQuery.new }

          it 'raises an error when a query is run' do
            expect { query.execute }.to raise_error NotImplementedError
          end
        end

        context 'when the query class defines a custom result format' do
          class CustomResultsQuery
            include Queryable

            def as_hash
              { query: 'foo' }
            end

            def parse_results(raw_results)
              { custom_format: raw_results }
            end
          end

          subject(:query) { CustomResultsQuery.new }

          describe '#execute' do
            it 'provides the search results in a custom format' do
              query.index.stub(:search).and_return({ foo: :bar})
              expect(query.execute).to eql({ custom_format: { foo: :bar } })
            end
          end

          describe '#index_name' do
            it 'provides the index_name from the config' do
              expect(query.index_name).to eql 'test_index'
            end
          end

        end

      end
    end
  end
end

