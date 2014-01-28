module Elasticsearch
  module Extensions
    module Documentor
      class QueryBase

        def as_hash
          raise NotImplementedError, "#{self.class.name} should implement #as_hash method"
        end

        def execute
          raw_results = index.search(self)
          parse_results(raw_results)
        end

        def parse_results(raw_results)
          raw_results
        end

        def index_name
          Elasticsearch::Extensions::Documentor.index_name
        end

        def index
          @index ||= Elasticsearch::Extensions::Documentor::Index.new
        end

      end
    end
  end
end

