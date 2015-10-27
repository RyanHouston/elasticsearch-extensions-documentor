module Elasticsearch
  module Extensions
    module Documents
      class DirectIndexStore
        attr_reader :client, :storage

        def initialize(options = {})
          @client  = options.fetch(:client)  { Documents.client }
          @storage = options.fetch(:storage) { Storage.new }
        end

        def index(payload)
          client.index payload.merge(index: Documents.index_name)
        end

        def delete(payload)
          client.delete payload.merge(index: Documents.index_name)
        end

        def search(payload)
          client.search payload.merge(index: Documents.index_name)
        end

        def refresh
          client.indices.refresh index: Documents.index_name
        end

        def reindex(options = {}, &block)
          force_create = options.fetch(:force_create) { false }

          storage.drop_index(Documents.index_name) if force_create
          storage.create_index(Documents.index_name)

          block.call(self) if block_given?
        end

        def setup
          storage.drop_index(Documents.index_name)
          storage.create_index(Documents.index_name)
        end

        def bulk_index(documents)
          client.bulk body: bulk_index_operations(documents)
        end

        def bulk_index_operations(documents)
          documents.collect { |document| bulk_index_operation_hash(document) }
        end

        def bulk_index_operation_hash(document)
          {
            index: {
              _index: Documents.index_name,
              _type:  document.class.type,
              _id:    document.id,
              data:   document.as_hash,
            }
          }
        end

      end
    end
  end
end

