require 'spec_helper'
require 'elasticsearch/extensions/documentor/utils'

module Elasticsearch
  module Extensions
    module Documentor
      describe Utils do

        describe '.sanitize_for_query_string_query' do
          subject { Utils.public_method(:sanitize_for_query_string_query) }

          it 'escapes special syntax characters' do
            %w(/ \\ + - & | ! ( ) { } [ ] ^ ~ * ? :).each do |char|
              term = 'a' + char + 'b'
              sanitized_term = 'a\\' + char + 'b'
              expect(subject.call(term)).to eq sanitized_term
            end
          end

          it 'escapes boolean terms' do
            term = 'this AND that'
            expect(subject.call(term)).to eq 'this \A\N\D that'
            term = 'this OR that'
            expect(subject.call(term)).to eq 'this \O\R that'
            term = 'this NOT that'
            expect(subject.call(term)).to eq 'this \N\O\T that'
          end

          it 'escapes odd quotes' do
            term = 'A "quoted" te"m'
            expect(subject.call(term)).to eq 'A "quoted" te\"m'
          end
        end

      end
    end
  end
end

