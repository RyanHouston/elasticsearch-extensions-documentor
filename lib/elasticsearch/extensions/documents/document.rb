module Elasticsearch
  module Extensions
    module Documents
      class Document
        attr_reader :model

        def initialize(model)
          @model = model
        end

        class << self
          def indexes_as_type(type)
            @index_type = type.to_s
          end

          attr_reader :index_type
          alias :type :index_type
        end

        def id
          model.id
        end

        def as_hash
          raise NotImplementedError, 'A subclass should define this method'
        end

      end
    end
  end
end

