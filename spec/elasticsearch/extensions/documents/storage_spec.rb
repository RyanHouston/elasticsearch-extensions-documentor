require 'spec_helper'

module Elasticsearch
  module Extensions
    module Documents
      describe Storage do

        let(:indices) { double(:indices) }
        let(:client) { double(:client, indices: indices) }
        subject(:storage) { described_class.new(client: client) }

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
            storage.create_index('test_index')
          end

          it 'does not create the index if it exists' do
            indices.stub(:exists).and_return(true)
            expect(indices).not_to receive(:create)
            storage.create_index('test_index')
          end
        end

        describe '#drop_index' do
          it 'drops the index if it exists' do
            indices.stub(:exists).and_return(true)
            expect(indices).to receive(:delete)
            storage.drop_index('test_index')
          end

          it 'does not drop the index if it does not exist' do
            indices.stub(:exists).and_return(false)
            expect(indices).not_to receive(:delete)
            storage.drop_index('test_index')
          end
        end

        describe '#index_exists?' do
          it 'delegates to the client indices' do
            expect(indices).to receive(:exists).with(index: 'test_index')
            storage.index_exists?('test_index')
          end
        end

      end
    end
  end
end

