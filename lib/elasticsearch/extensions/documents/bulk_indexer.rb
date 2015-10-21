module Elasticsearch
  module Extensions
    module Documents
      class BulkIndexer

        attr_reader :client

        def initialize(options = {})
          @client = options.fetch(:client) { Documents.client }
        end

        def index(documents)
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

