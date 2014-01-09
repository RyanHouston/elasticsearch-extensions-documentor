# Elasticsearch::Extensions::Documentor

A service wrapper to manage Elasticsearch index documents

## Installation

Add this line to your application's Gemfile:

    gem 'elasticsearch-extensions-documentor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticsearch-extensions-documentor

## Configuration

Before making any calls to Elasticsearch you need to configure the `Documentor`
extension.

```ruby
ES_MAPPINGS = {
  user: {
    _all: { analyzer: "snowball" },
    properties: {
      id:   { type: "integer", index: :not_analyzed },
      name: { type: "string", analyzer: "snowball" },
      bio:  { type: "string", analyzer: "snowball" },
      updated_at:   { type: "date", include_in_all: false }
    }
  }
}

ES_SETTINGS = {
  index: {
    number_of_shards: 3,
    number_of_replicas: 2,
  }
}

Elasticsearch::Extensions::Documentor.configure do |config|
  config.url        = 'http://example.com:9200' # your elasticsearch endpoint
  config.index_name = 'test_index'              # the name of your index
  config.mappings   = ES_MAPPINGS               # a hash containing your index mappings
  config.settings   = ES_SETTINGS               # a hash containing your index settings
  config.logger     = Logger.new(STDOUT)        # the logger to use. (defaults to Logger.new(STDOUT)
  config.log        = true                      # if the elasticsearch-ruby should provide logging
end
```

If you are using this extension with a Rails application this configuration
could live in an initializer like `config/initializers/elasticsearch.rb`.

## Usage

The `Documentor` extension builds on the
`elasticsearch-ruby` Gem adding conventions and helper classes to aide in the
serialization and flow of data between your application code and the
elasticsearch-ruby interface. To accomplish this the application data models
will be serialized into `Document`s that can be indexed and searched with the
`elasticsearch-ruby` Gem.

### Saving a Document
If your application has a model called `User` that you wanted to index you would
create a `Document` that defined how the `User` is stored in the index.

```ruby
class UserDocument < Elasticsearch::Extensions::Documentor::Document
  indexes_as_type :user

  def as_hash
    {
      name:   object.name,
      title:  object.title,
      bio:    object.bio,
    }
  end

end

user = User.new  # could be a PORO or an ActiveRecord model
user_doc = UserDocument.new(user)

index = Elasticsearch::Extensions::Documentor::Index.new
index.index(user_doc)
```

### Deleting a Document
Deleting a document is just as easy

```ruby
user_doc = UserDocument.new(user)
index.delete(user_doc)
```

### Searching for Documents
Create classes which implement a `#as_hash` method to act as a catalog of your
search queries. The `#as_hash` method can use Jbuilder or anything else to
generate the hash. This hash should be formatted appropriately to be passed on
to the `Elasticsearch::Transport::Client#search` method.

```ruby
class GeneralSiteSearchQuery
  def as_hash
    {
      query: {
        query_string: {
          analyzer: "snowball",
          query:    "something to search for",
        }
      }
    }
  end
end
```

You could elaborate on this class with a constructor that takes the search
term and other options specific to your use case as arguments.

```ruby
results = index.search(query)
results.hits.total
results.hits.max_score
results.hits.hits.each { |hit| puts hit._source.inspect }
```

The results returned from this method wrap the raw hash from
`Elasticsearch::Transport::Client#search` in a
[`Hashie::Mash`](https://github.com/intridea/hashie) instance to allow object
like access to the response hash.

### Index Management

The Indexer uses the `Elasticsearch::Extensions::Documentor.configuration`
to create the index with the configured `#index_name`, `#mappings`, and
`#settings`.

```ruby
indexer = Elasticsearch::Extensions::Documentor::Indexer.new
indexer.create_index
indexer.drop_index
```

The `Indexer` can `#batch_index` documents sending multiple documents to
Elasticsearch in a single request. This may be more efficient when
programmatically re-indexing entire sets of documents.

```ruby
user_documents = users.collect { |user| UserDocument.new(user) }
indexer.batch_index(user_documents)
```

The `Indexer` accepts a block to the `#reindex` method to encapsulate the
processes of dropping the old index, creating a new index with the latest
configured mappings and settings, and bulk indexing a set of documents into the
newly created index. The content of the block should be the code that creates
your documents in batches and passes them to the `#bulk_index` method of the
`Indexer`.

```ruby
indexer.reindex do |indexer|

  # For ActiveRecord you may want to find_in_batches
  User.find_in_batches(batch_size: 500) do |batch|
    documents = batch.map { |user| UserDocument.new(user) }
    indexer.batch_index(documents)
  end

  # Otherwise you can add whatever logic you need to bulk index your documents
  documents = users.map { |model| UserDocument.new(model) }
  indexer.batch_index(documents)
end
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

