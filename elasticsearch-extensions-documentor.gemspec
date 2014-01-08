# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/extensions/documentor/version'

Gem::Specification.new do |spec|
  spec.name          = "elasticsearch-extensions-documentor"
  spec.version       = Elasticsearch::Extensions::Documentor::VERSION
  spec.authors       = ["Ryan Houston"]
  spec.email         = ["ryanhouston83@gmail.com"]
  spec.description   = %q{A service wrapper to manage elasticsearch index documents}
  spec.summary       = %q{Define mappings to turn model instances into indexable search documents}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "elasticsearch"
  spec.add_runtime_dependency "hashie"
end

