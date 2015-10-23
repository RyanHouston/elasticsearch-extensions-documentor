require "elasticsearch"
require "logger"
require "ostruct"
require "elasticsearch/extensions/documents/version"
require "elasticsearch/extensions/documents/document"
require "elasticsearch/extensions/documents/index"
require "elasticsearch/extensions/documents/aliased_index_store"
require "elasticsearch/extensions/documents/direct_index_store"
require "elasticsearch/extensions/documents/queryable"
require "elasticsearch/extensions/documents/storage"
require "elasticsearch/extensions/documents/utils"

module Elasticsearch
  module Extensions
    module Documents

      class << self
        attr_accessor :client, :configuration

        def client
          Elasticsearch::Client.new(configuration.client.marshal_dump)
        end

        def configure
          self.configuration ||= OpenStruct.new(client: OpenStruct.new)
          yield configuration
        end

        def index_name
          self.configuration.index_name
        end

        def logger
          self.configuration.client.logger ||= Logger.new(STDERR)
        end

        def index_adapter
          case self.configuration.index_adapter
          when :direct then DirectIndexStore.new
          when :aliased then AliasedIndexStore.new
          else DirectIndexStore.new end
        end

      end

    end
  end
end

