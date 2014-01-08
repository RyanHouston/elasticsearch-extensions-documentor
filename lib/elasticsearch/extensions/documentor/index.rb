require 'hashie/mash'

module Elasticsearch
  module Extensions
    module Documentor
      class Index
        attr_reader :client

        def initialize(client = nil)
          @client = client || Documentor.client
        end

        def index(document)
          payload = {
            index:  Documentor.index_name,
            type:   document.class.type,
            id:     document.id,
            body:   document.as_hash,
          }
          client.index payload
        end

        def delete(document)
          payload = {
            index:  Documentor.index_name,
            type:   document.class.type,
            id:     document.id,
          }
          client.delete payload
        rescue Elasticsearch::Transport::Transport::Errors::NotFound => not_found
          Documentor.logger.info "[Documentor] Attempted to delete missing document: #{not_found}"
        end

        def search(query)
          response = client.search(query.as_hash)
          Hashie::Mash.new(response)
        end

        def refresh
          client.indices.refresh index: Documentor.index_name
        end

      end
    end
  end
end

