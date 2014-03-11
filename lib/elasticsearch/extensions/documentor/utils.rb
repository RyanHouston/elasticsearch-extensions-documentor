module Elasticsearch
  module Extensions
    module Documents
      module Utils

        def self.sanitize_for_query_string_query(query_string)
          # http://stackoverflow.com/questions/16205341/symbols-in-query-string-for-elasticse
          # Escape special characters
          # http://lucene.apache.org/core/old_versioned_docs/versions/2_9_1/queryparsersyntax
          escaped_characters = Regexp.escape('/\\+-&|!(){}[]^~*?:')
          query_string = query_string.gsub(/([#{escaped_characters}])/, '\\\\\1')

          # AND, OR and NOT are used by lucene as logical operators. We need
          # to escape them
          ['AND', 'OR', 'NOT'].each do |word|
            escaped_word = word.split('').map {|char| "\\#{char}" }.join('')
            query_string = query_string.gsub(/\s*\b(#{word.upcase})\b\s*/, " #{escaped_word} ")
          end

          # Escape odd quotes
          quote_count = query_string.count '"'
          query_string = query_string.gsub(/(.*)"(.*)/, '\1\"\2') if quote_count % 2 == 1

          query_string
        end

      end
    end
  end
end

