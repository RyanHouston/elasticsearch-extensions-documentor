require 'elasticsearch-documents'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end

Elasticsearch::Extensions::Documents.configure do |config|
  config.url        = 'http://example.com:9200'
  config.index_name = 'test_index'
  config.settings   = :fake_settings
  config.mappings   = :fake_mappings
end

class TestDocumentsDocument < Elasticsearch::Extensions::Documents::Document
  indexes_as_type :documents_test

  def as_hash
    {
      a: object.a,
      b: object.b,
    }
  end
end

