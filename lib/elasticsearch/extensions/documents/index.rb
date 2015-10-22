require 'hashie/mash'

module Elasticsearch
  module Extensions
    module Documents
      class Index
        attr_reader :adapter

        def initialize(adapter = nil)
          @adapter = adapter || DirectIndexStore.new
        end

        def index(document)
          payload = {
            index:  Documents.index_name,
            type:   document.class.type,
            id:     document.id,
            body:   document.as_hash,
          }
          adapter.index payload
        end

        def delete(document)
          payload = {
            index:  Documents.index_name,
            type:   document.class.type,
            id:     document.id,
          }
          adapter.delete payload
        rescue Elasticsearch::Transport::Transport::Errors::NotFound => not_found
          Documents.logger.info "[Documents] Attempted to delete missing document: #{not_found}"
        end

        def search(query)
          defaults    = { index: Documents.index_name }
          search_hash = defaults.merge(query.as_hash)
          response    = adapter.search(search_hash)
          Hashie::Mash.new(response)
        end

        def refresh
          adapter.refresh
        end

      end
    end
  end
end

