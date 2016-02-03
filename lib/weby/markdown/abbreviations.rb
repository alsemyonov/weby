require 'weby/markdown'

class Weby
  module Markdown
    module Abbreviations
      REGEXP = /^\*\[([^\]]+)\]:\s+(.*)$/

      def preprocess(document)
        abbreviations = document.scan(REGEXP)
        abbreviations = Hash[*abbreviations.flatten]

        if abbreviations.any?
          document.gsub!(REGEXP, '')
          document.rstrip!

          abbreviations.each do |key, value|
            html = %(<abbr title="#{value}">#{key}</abbr>)

            document.gsub!(acronym_regexp(key), html)
          end
        end

        document
      end

      def acronym_regexp(acronym)
        /\b#{acronym}\b/
      end
    end
  end
end
