Elasticsearch::Extensions::Documents.configure do |config|
  config.index_name = 'documents_test'
  config.settings   = {}
  config.mappings   = {}
  config.client.url = 'http://localhost:9200'
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


