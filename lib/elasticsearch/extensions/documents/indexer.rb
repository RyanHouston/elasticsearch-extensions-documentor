module Elasticsearch
  module Extensions
    module Documents
      class Indexer
        attr_reader :client, :storage

        def initialize(options = {})
          @client = options.fetch(:client) { Documents.client }
          @storage = options.fetch(:storage) { Storage.new }
        end

        def index(payload)
          client.index payload
        end

        def delete(payload)
          client.delete payload
        end

        def search(payload)
          client.search payload
        end

        def refresh
          client.indices.refresh index: Documents.index_name
        end

        def reindex(options = {}, &block)
          force_create = options.fetch(:force_create) { false }

          storage.drop_index if force_create
          storage.create_index

          block.call(self) if block_given?
        end

      end
    end
  end
end

