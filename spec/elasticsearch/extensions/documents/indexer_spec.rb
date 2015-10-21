require 'spec_helper'

module Elasticsearch
  module Extensions
    module Documents
      describe Indexer do

        let(:indices) { double(:indices) }
        let(:client) { double(:client, indices: indices) }
        subject(:indexer) { Indexer.new(client: client) }

        describe '#create_index' do
          it 'creates the index if it does not exist' do
            expected_client_params = {
              index: 'test_index',
              body:  {
                settings: :fake_settings,
                mappings: :fake_mappings,
              }
            }
            indices.stub(:exists).and_return(false)
            expect(indices).to receive(:create).with(expected_client_params)
            indexer.create_index
          end

          it 'does not create the index if it exists' do
            indices.stub(:exists).and_return(true)
            expect(indices).not_to receive(:create)
            indexer.create_index
          end
        end

        describe '#drop_index' do
          it 'drops the index if it exists' do
            indices.stub(:exists).and_return(true)
            expect(indices).to receive(:delete)
            indexer.drop_index
          end

          it 'does not drop the index if it does not exist' do
            indices.stub(:exists).and_return(false)
            expect(indices).not_to receive(:delete)
            indexer.drop_index
          end
        end

        describe '#index_exists?' do
          it 'delegates to the client indices' do
            expect(indices).to receive(:exists).with(index: 'test_index')
            indexer.index_exists?
          end
        end

        describe '#reindex' do

          context 'with the :force_create option' do
            it 'drops the index if exists' do
              indices.stub(:exists).and_return(true)
              expect(indexer).to receive(:drop_index)
              indexer.reindex(force_create: true)
            end
          end

          context 'without the :force_create option' do
            it 'does not drop the index if exists' do
              indices.stub(:exists).and_return(true)
              expect(indexer).not_to receive(:drop_index)
              indexer.reindex
            end
          end

          it 'creates a new index' do
            indices.stub(:exists).and_return(false)
            expect(indexer).to receive(:create_index)
            indexer.reindex
          end

          it 'calls a given block to batch index the documents' do
            indexer.stub(:drop_index)
            indexer.stub(:create_index)
            documents = double(:documents)
            expect(indexer).to receive(:bulk_index).with(documents)
            indexer.reindex { |indexer| indexer.bulk_index(documents) }
          end

        end

      end
    end
  end
end

