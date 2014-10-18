require 'hashie/mash'

module Elasticsearch
  module Extensions
    module Documents
      class Index
        attr_reader :client

        def initialize(client = nil)
          @client = client || Documents.client
        end

        def index(document)
          payload = {
            index:  Documents.index_name,
            type:   document.class.type,
            id:     document.id,
            body:   document.as_hash,
          }
          client.index payload
        end

        def delete(document)
          payload = {
            index:  Documents.index_name,
            type:   document.class.type,
            id:     document.id,
          }
          client.delete payload
        rescue Elasticsearch::Transport::Transport::Errors::NotFound => not_found
          Documents.logger.info "[Documents] Attempted to delete missing document: #{not_found}"
        end

        def search(query)
          defaults    = { index: Documents.index_name }
          search_hash = defaults.merge(query.as_hash)
          response    = client.search(search_hash)
          Hashie::Mash.new(response)
        end

        def refresh
          client.indices.refresh index: Documents.index_name
        end

      end
    end
  end
end

