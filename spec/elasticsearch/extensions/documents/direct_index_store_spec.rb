require 'spec_helper'

module Elasticsearch
  module Extensions
    module Documents
      describe DirectIndexStore do

        let(:client) { double(:client) }
        let(:storage) { double(:storage) }
        subject(:store) { described_class.new(client: client, storage: storage) }

        describe '#reindex' do
          before(:each) do
            storage.stub(:create_index)
            storage.stub(:drop_index)
          end

          context 'with the :force_create option' do
            it 'drops the index if exists' do
              expect(storage).to receive(:drop_index)
              store.reindex(force_create: true)
            end
          end

          context 'without the :force_create option' do
            it 'does not drop the index if exists' do
              expect(storage).not_to receive(:drop_index)
              store.reindex
            end
          end

          it 'creates a new index' do
            expect(storage).to receive(:create_index)
            store.reindex
          end

          it 'calls a given block to batch index the documents' do
            documents = double(:documents)
            expect(store).to receive(:bulk_index).with(documents)
            store.reindex { |store| store.bulk_index(documents) }
          end

        end

        describe "#bulk_index" do
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
            store.bulk_index(documents)
          end
        end
      end
    end
  end
end

