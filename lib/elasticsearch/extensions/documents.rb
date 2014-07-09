require "elasticsearch"
require "logger"
require "ostruct"
require "elasticsearch/extensions/documents/version"
require "elasticsearch/extensions/documents/document"
require "elasticsearch/extensions/documents/index"
require "elasticsearch/extensions/documents/indexer"
require "elasticsearch/extensions/documents/queryable"
require "elasticsearch/extensions/documents/utils"

module Elasticsearch
  module Extensions
    module Documents

      class << self
        attr_accessor :client, :configuration

        def client
          Elasticsearch::Client.new(configuration.marshal_dump)
        end

        def configure
          self.configuration ||= OpenStruct.new
          yield configuration
        end

        def index_name
          self.configuration.index_name
        end

        def logger
          self.configuration.logger ||= Logger.new(STDERR)
        end
      end

    end
  end
end

