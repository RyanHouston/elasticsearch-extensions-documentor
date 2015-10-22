require 'spec_helper'

module Elasticsearch
  module Extensions
    module Documents
      describe Indexer do

        let(:client) { double(:client) }
        let(:storage) { double(:storage) }
        subject(:indexer) { Indexer.new(client: client, storage: storage) }

        describe '#reindex' do
          before(:each) do
            storage.stub(:create_index)
            storage.stub(:drop_index)
          end

          context 'with the :force_create option' do
            it 'drops the index if exists' do
              expect(storage).to receive(:drop_index)
              indexer.reindex(force_create: true)
            end
          end

          context 'without the :force_create option' do
            it 'does not drop the index if exists' do
              expect(storage).not_to receive(:drop_index)
              indexer.reindex
            end
          end

          it 'creates a new index' do
            expect(storage).to receive(:create_index)
            indexer.reindex
          end

          it 'calls a given block to batch index the documents' do
            documents = double(:documents)
            expect(indexer).to receive(:bulk_index).with(documents)
            indexer.reindex { |indexer| indexer.bulk_index(documents) }
          end

        end

      end
    end
  end
end

