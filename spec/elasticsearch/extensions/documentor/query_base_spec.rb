require 'spec_helper'
require 'elasticsearch/extensions/documentor/query_base'

module Elasticsearch
  module Extensions
    module Documentor
      describe QueryBase do

        context 'when a subclass is not correctly implemented' do
          subject(:query) { Class.new(QueryBase).new }

          it 'raises an error when a query is run' do
            expect { query.execute }.to raise_error NotImplementedError
          end
        end

        context 'when the query class defines a custom result format' do
          class CustomResultsQuery < QueryBase
            def as_hash
              { query: 'foo' }
            end

            def parse_results(raw_results)
              { custom_format: raw_results }
            end
          end

          subject(:query) { CustomResultsQuery.new }

          it 'provides the search results in a custom format' do
            query.index.stub(:search).and_return({ foo: :bar})
            expect(query.execute).to eql({ custom_format: { foo: :bar } })
          end

        end

      end
    end
  end
end

