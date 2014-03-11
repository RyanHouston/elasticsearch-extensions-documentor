require 'spec_helper'

module Elasticsearch
  module Extensions
    module Documents
      Documents.configure {|config| config.index_name = 'test_index' }

      describe Document do
        let(:document_class) { Class.new(Elasticsearch::Extensions::Documents::Document) }
        let(:model) { double(:model) }
        subject(:document) { document_class.new(model) }

        describe '.indexes_as_type' do
          it 'sets the index type name' do
            document_class.indexes_as_type('test_type')
            expect(document_class.index_type).to eq 'test_type'
            expect(document_class.type).to eq 'test_type'
          end
        end

        describe '#id' do
          it 'delegates to the model' do
            expect(model).to receive(:id)
            document.id
          end
        end

        describe '#as_hash' do
          it 'raises an error if not redefined by a subclass' do
            expect{ document.as_hash }.to raise_error NotImplementedError
          end
        end

      end
    end
  end
end

