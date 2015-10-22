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

      end
    end
  end
end

