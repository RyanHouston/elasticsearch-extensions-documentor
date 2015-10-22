require 'hashie/mash'

module Elasticsearch
  module Extensions
    module Documents
      class Index
        attr_reader :adapter

        def initialize(adapter = nil)
          @adapter = adapter || Documents.index_adapter
        end

        def index(document)
          payload = {
            type:   document.class.type,
            id:     document.id,
            body:   document.as_hash,
          }
          adapter.index payload
        end

        def delete(document)
          payload = {
            type:   document.class.type,
            id:     document.id,
          }
          adapter.delete payload
        rescue Elasticsearch::Transport::Transport::Errors::NotFound => not_found
          Documents.logger.info "[Documents] Attempted to delete missing document: #{not_found}"
        end

        def search(query)
          response = adapter.search(query.as_hash)
          Hashie::Mash.new(response)
        end

        def refresh
          adapter.refresh
        end

        def reindex(options = {}, &block)
          adapter.reindex(options, &block)
        end

      end
    end
  end
end

