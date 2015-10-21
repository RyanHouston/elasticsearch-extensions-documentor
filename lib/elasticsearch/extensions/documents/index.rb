require 'hashie/mash'

module Elasticsearch
  module Extensions
    module Documents
      class Index
        attr_reader :indexer

        def initialize(indexer = nil)
          @indexer = indexer || Indexer.new
        end

        def index(document)
          payload = {
            index:  Documents.index_name,
            type:   document.class.type,
            id:     document.id,
            body:   document.as_hash,
          }
          indexer.index payload
        end

        def delete(document)
          payload = {
            index:  Documents.index_name,
            type:   document.class.type,
            id:     document.id,
          }
          indexer.delete payload
        rescue Elasticsearch::Transport::Transport::Errors::NotFound => not_found
          Documents.logger.info "[Documents] Attempted to delete missing document: #{not_found}"
        end

        def search(query)
          defaults    = { index: Documents.index_name }
          search_hash = defaults.merge(query.as_hash)
          response    = indexer.search(search_hash)
          Hashie::Mash.new(response)
        end

        def refresh
          indexer.refresh
        end

      end
    end
  end
end

