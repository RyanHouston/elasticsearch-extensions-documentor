require "elasticsearch"
require "logger"
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
          Elasticsearch::Client.new({
            host: self.configuration.url,
            log:  self.configuration.log,
          })
        end

        def configure
          self.configuration ||= Configuration.new
          yield configuration
        end

        def index_name
          self.configuration.index_name
        end

        def logger
          self.configuration.logger
        end
      end

      class Configuration
        attr_accessor :url, :index_name, :mappings, :settings, :log, :logger

        def initialize
          @logger = Logger.new(STDOUT)
          @log    = true
        end
      end

    end
  end
end

