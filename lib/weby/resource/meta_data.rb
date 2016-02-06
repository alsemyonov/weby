require 'weby/resource'

class Weby
  module Resource
    module MetaData
      # The title of the article, set from frontmatter.
      # @return [String]
      def title
        data['title'] || File.basename(path, '.*').humanize
      end

      # @return [String]
      def description
        data['description']
      end

      # @return [String]
      def keywords
        data['keywords'] || data['tags']
      end

      # @return [<{name: String, content: String}>]
      def to_meta
        meta = %i(description keywords).collect do |property|
          value = public_send(property)
          { name: property, content: value } if value
        end.compact
        meta << { name: :author, content: author.name } if author
        meta << { name: :generator, content: "Weby/#{Weby.version}" }
        meta << { name: :debug, content: "Environment: #{weby.app.environment}" }
        if data.nofollow
          meta << { name: 'robots', content: data.nofollow.presence || 'noindex, nofollow' }
        else
          meta << { name: 'robots', content: 'index, follow' }
        end
        meta
      end
    end

    include MetaData
  end
end
