require 'elasticsearch-extensions-documentor'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end

Elasticsearch::Extensions::Documentor.configure do |config|
  config.url        = 'http://example.com:9200'
  config.index_name = 'test_index'
  config.settings   = :fake_settings
  config.mappings   = :fake_mappings
end

class TestDocumentorDocument < Elasticsearch::Extensions::Documentor::Document
  indexes_as_type :documentor_test

  def as_hash
    {
      a: model.a,
      b: model.b,
    }
  end
end

