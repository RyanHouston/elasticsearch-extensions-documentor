module Elasticsearch
  module Extensions
    module Documents
      class Indexer
        attr_reader :client, :config

        def initialize(options = {})
          @client = options.fetch(:client) { Documents.client }
          @config = options.fetch(:config) { Documents.configuration }
        end

        def drop_index
          client.indices.delete(index: config.index_name) if index_exists?
        end

        def index_exists?
          client.indices.exists(index: config.index_name)
        end

        def create_index
          client.indices.create(index: config.index_name, body: create_index_body) unless index_exists?
        end

        def create_index_body
          {}.tap do |body|
            body[:settings] = config.settings if config.settings
            body[:mappings] = config.mappings if config.mappings
          end
        end

        def reindex(options = {}, &block)
          force_create = options.fetch(:force_create) { false }

          drop_index if force_create
          create_index

          block.call(self) if block_given?
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
              _index: config.index_name,
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

