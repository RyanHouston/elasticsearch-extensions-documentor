# Elasticsearch::Extensions::Documents

A service wrapper to manage Elasticsearch index documents

## Installation

Add this line to your application's Gemfile:

    gem 'elasticsearch-extensions-documents'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticsearch-extensions-documents

## Usage

### Configuration

```ruby
Elasticsearch::Extensions::Documents.configure do |config|
  config.url        = 'http://example.com:9200' # your elasticsearch endpoint
  config.index_name = 'test_index'              # the name of your index
  config.mappings   = { mappings: :here }       # a hash containing your index mappings
  config.settings   = { settings: :here }       # a hash containing your index settings
  config.logger     = Logger.new(STDOUT)        # the logger to use. (defaults to Logger.new(STDOUT)
  config.log        = true                      # if the elasticsearch-ruby should provide logging
end
```

### Documents

The `Documents` extension provides a serialization layer aimed to ease the
amount of work required to transform your application's data into Documents that
can be indexed and searched in an Elasticsearch index. `Documents` uses the
`elasticsearch-ruby` Gem for all interactions with the Elasticsearch server.

#### Saving Documents
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
Elasticsearch::Extensions::Documents.new.index(user_doc)
```

#### Deleting Documents
Deleting a document is just as easy

```ruby
user_doc = UserDocument.new(user)
Elasticsearch::Extensions::Documents.new.delete(user_doc)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

