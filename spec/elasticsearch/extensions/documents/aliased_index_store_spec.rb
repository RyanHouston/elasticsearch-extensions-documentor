require 'spec_helper'

module Elasticsearch
  module Extensions
    module Documents
      describe AliasedIndexStore do

        let(:client) { double(:client) }
        let(:storage) { double(:storage) }
        subject(:store) { described_class.new(client: client, storage: storage) }

        describe "#index" do
          it "tells the client to index using a write alias" do
            expect(client).to receive(:index).with({ foo: :bar, index: "test_index_write" })
            store.index(foo: :bar)
          end
        end

        describe "#delete" do
          it "tells the client to delete a document using the write alias" do
            expect(client).to receive(:delete).with({ id: 42, index: "test_index_write"})
            store.delete(id: 42)
          end
        end

        describe "#search" do
          it "tells the client to search from the read alias" do
            expect(client).to receive(:search).with({ foo: :bar,  index: "test_index_read"})
            store.search(foo: :bar)
          end
        end

        describe "#refresh" do
          it "tells the client indices to refresh the read alias" do
            indices = double(:indices)
            client.stub(:indices).and_return(indices)
            expect(indices).to receive(:refresh).with(index: "test_index_read")
            store.refresh
          end
        end

        describe "#reindex" do
          let(:indices) { double(:indices) }
          before(:each) do
            allow(store).to receive(:index_for_alias)
            allow(indices).to receive(:update_aliases)
            allow(storage).to receive(:create_index)
            allow(storage).to receive(:drop_index)
            client.stub(:indices).and_return(indices)
            time = double(:time, now: self, strftime: "timestamp")
            Time.stub(:now).and_return(time)
          end

          it "creates a new index with a timestamp appended to the name" do
            expect(storage).to receive(:create_index).with("test_index_timestamp")
            store.reindex
          end

          it "points the write alias to the newly created index" do
            swap_args = {
              alias: "test_index_write",
              old:   "test_index_old",
              new:   "test_index_timestamp",
            }

            allow(store).to receive(:index_for_alias).and_return("test_index_old")
            expect(store).to receive(:swap_index_alias).with(swap_args)
            expect(store).to receive(:swap_index_alias)

            store.reindex
          end

          it "points the read alias to the newly created index" do
            swap_args = {
              alias: "test_index_read",
              old:   "test_index_old",
              new:   "test_index_timestamp",
            }

            allow(store).to receive(:index_for_alias).and_return("test_index_old")
            expect(store).to receive(:swap_index_alias).with(swap_args)
            expect(store).to receive(:swap_index_alias)

            store.reindex
          end

          it "calls a given block to index the documents" do
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
                    _index: 'test_index_write',
                    _type:  'documents_test',
                    _id:    1,
                    data:   { a: 1, b: 2 },
                  }
                },
                {
                  index: {
                    _index: 'test_index_write',
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

