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

      end
    end
  end
end

