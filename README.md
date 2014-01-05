# Elasticsearch::Documents

A service wrapper to manage Elasticsearch index documents

## Installation

Add this line to your application's Gemfile:

    gem 'elasticsearch-documents'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticsearch-documents

## Usage

### Configuration
```ruby
Elasticsearch::Documents.configure do |config|
  config.url        = 'http://example.com:9200' # your elasticsearch endpoint
  config.index_name = 'test_index'              # the name of your index
  config.mappings   = { mappings: :here }       # a hash containing your index mappings
  config.settings   = { settings: :here }       # a hash containing your index settings
  config.logger     = Logger.new(STDOUT)        # the logger to use. (defaults to Logger.new(STDOUT)
  config.log        = true                      # if the elasticsearch-ruby should provide logging
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

