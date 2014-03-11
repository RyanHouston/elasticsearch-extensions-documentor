module Elasticsearch
  module Extensions
    module Documents
      module Queryable

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
          Elasticsearch::Extensions::Documents.index_name
        end

        def index
          @index ||= Elasticsearch::Extensions::Documents::Index.new
        end

      end
    end
  end
end

