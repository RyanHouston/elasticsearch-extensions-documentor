module Elasticsearch
  module Extensions
    module Documents
      class Storage

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
          client.indices.create(index: config.index_name, body: index_definition) unless index_exists?
        end

        def index_definition
          {}.tap do |body|
            body[:settings] = config.settings if config.settings
            body[:mappings] = config.mappings if config.mappings
          end
        end

      end
    end
  end
end

