module Elasticsearch
  module Extensions
    module Documentor
      class Document
        attr_reader :object

        def initialize(object)
          @object = object
        end

        class << self
          def indexes_as_type(type)
            @index_type = type.to_s
          end

          attr_reader :index_type
          alias :type :index_type
        end

        def id
          object.id
        end

        def as_hash
          raise NotImplementedError, 'A subclass should define this method'
        end

      end
    end
  end
end

