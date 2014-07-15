# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/extensions/documents/version'

Gem::Specification.new do |spec|
  spec.name          = "elasticsearch-documents"
  spec.version       = Elasticsearch::Extensions::Documents::VERSION
  spec.required_ruby_version = ">= 1.9.3"

  spec.authors       = ["Ryan Houston"]
  spec.email         = ["ryanhouston83@gmail.com"]
  spec.summary       = %q{A service wrapper to manage elasticsearch index documents}
  spec.description   = %q{Define mappings to turn model instances into indexable search documents}
  spec.homepage      = "http://github.com/RyanHouston/elasticsearch-documents"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"

  spec.add_runtime_dependency "elasticsearch"
  spec.add_runtime_dependency "hashie"
end

