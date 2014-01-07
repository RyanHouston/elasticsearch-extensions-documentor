# Elasticsearch::Extensions::Documents

A service wrapper to manage Elasticsearch index documents

## Installation

Add this line to your application's Gemfile:

    gem 'elasticsearch-extensions-documents'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticsearch-extensions-documents

## Configuration

Before making any calls to Elasticsearch you need to configure the `Documents`
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

Elasticsearch::Extensions::Documents.configure do |config|
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

The `Documents` extension provides a serialization layer aimed to ease the
amount of work required to transform your application's data into Documents that
can be indexed and searched in an Elasticsearch index. `Documents` uses the
`elasticsearch-ruby` Gem for all interactions with the Elasticsearch server.

### Saving Documents
If your application has a model called `User` that you wanted to index you would
create a `Document` that defined how the `User` is stored in the index.

```ruby
class UserDocument < Elasticsearch::Extensions::Documents::Document
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

index = Elasticsearch::Extensions::Documents::Index.new
index.index(user_doc)
```

### Deleting Documents
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

