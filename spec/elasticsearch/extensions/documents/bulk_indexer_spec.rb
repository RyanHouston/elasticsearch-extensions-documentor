require "spec_helper"

module Elasticsearch
  module Extensions
    module Documents
      describe BulkIndexer do

        let(:indices) { double(:indices) }
        let(:client) { double(:client, indices: indices) }
        subject(:indexer) { described_class.new(client: client) }

        describe '#index' do
          let(:models) { [double(:model, id: 1, a: 1, b: 2), double(:model, id: 2, a: 3, b: 4)] }
          let(:documents) { models.map { |m| TestDocumentsDocument.new(m) } }

          it 'passes operations to the client bulk action' do
            expected_body = {
              body: [
                {
                  index: {
                    _index: 'test_index',
                    _type:  'documents_test',
                    _id:    1,
                    data:   { a: 1, b: 2 },
                  }
                },
                {
                  index: {
                    _index: 'test_index',
                    _type:  'documents_test',
                    _id:    2,
                    data:   { a: 3, b: 4 },
                  },
                }
              ]
            }
            expect(client).to receive(:bulk).with(expected_body)
            indexer.index(documents)
          end
        end

      end
    end
  end
end
