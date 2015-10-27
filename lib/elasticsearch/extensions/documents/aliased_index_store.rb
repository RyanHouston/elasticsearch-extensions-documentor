module Elasticsearch
  module Extensions
    module Documents
      class AliasedIndexStore

        attr_reader :client, :storage, :read_alias, :write_alias

        def initialize(options = {})
          @client      = options.fetch(:client)  { Documents.client }
          @storage     = options.fetch(:storage) { Storage.new }
          @write_alias = Documents.index_name + "_write"
          @read_alias  = Documents.index_name + "_read"
        end

        def index(payload)
          client.index payload.merge(index: write_alias)
        end

        def delete(payload)
          client.delete payload.merge(index: write_alias)
        end

        def search(payload)
          client.search payload.merge(index: read_alias)
        end

        def refresh
          client.indices.refresh index: read_alias
        end

        def reindex(options = {}, &block)
          timestamp      = Time.now.strftime('%Y%m%d-%H%M%S')
          new_index_name = Documents.index_name + "_#{timestamp}"
          current_index_name = indices_for_alias(write_alias).first

          storage.create_index new_index_name
          swap_index_alias(alias: write_alias, old: current_index_name, new: new_index_name)

          block.call(self) if block_given?

          swap_index_alias(alias: read_alias, old: current_index_name, new: new_index_name)
          storage.drop_index current_index_name
        end

        def indices_for_alias(alias_name)
          client.indices.get_alias(name: alias_name).keys
        end

        def setup
          reset_aliases

          timestamp      = Time.now.strftime('%Y%m%d-%H%M%S')
          new_index_name = Documents.index_name + "_#{timestamp}"

          storage.create_index new_index_name
          client.indices.put_alias index: new_index_name, name: read_alias
          client.indices.put_alias index: new_index_name, name: write_alias
        end

        def swap_index_alias(options)
          change_alias = options.fetch(:alias)
          new_index = options.fetch(:new)
          old_index = options.fetch(:old)

          client.indices.update_aliases body: {
            actions: [
              { remove: { index: old_index, alias: change_alias } },
              { add:    { index: new_index, alias: change_alias } },
            ]
          }
        end

        def reset_aliases
          if client.indices.exists_alias(name: write_alias)
            indices_for_alias(write_alias).each do |index|
              client.indices.delete_alias index: index, name: write_alias
            end
          end

          if client.indices.exists_alias(name: read_alias)
            indices_for_alias(read_alias).each do |index|
              client.indices.delete_alias index: index, name: read_alias
            end
          end
        end

        def bulk_index(documents)
          client.bulk body: bulk_index_operations(documents)
        end

        private

        def bulk_index_operations(documents)
          documents.collect { |document| bulk_index_operation_hash(document) }
        end

        def bulk_index_operation_hash(document)
          {
            index: {
              _index: write_alias,
              _type:  document.class.type,
              _id:    document.id,
              data:   document.as_hash,
            }
          }
        end

      end
    end
  end
end

