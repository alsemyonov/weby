require 'weby/extensions'

class Weby
  module Extensions
    module DataPage
      def self.extended(base)
        base.singleton_class.send(:attr_accessor, :resources_controller)
      end

      def resources_data
        resources_controller.data
      end

      def resources_options
        resources_controller.options
      end

      # The title of the article, set from frontmatter.
      # @return [String]
      def title
        data['title']
      end

      def description
        data['description']
      end

      def keywords
        data['keywords'] || data['tags']
      end

      def to_meta
        meta = %i(description keywords).collect do |property|
          value = public_send(property)
          { name: property, content: value } if value
        end.compact
        meta << { name: :author, content: author.name } if author
        meta << { name: :generator, content: "Weby/#{Weby::VERSION}" }
        meta
      end

      # Whether or not this article has been published.
      #
      # An article is considered published in the following scenarios:
      #
      # 1. Frontmatter does not set +published+ to false and either
      # 2. The +weby+ option +publish_future_dated+ is true or
      # 3. The article's date is after the current time
      # @return [Boolean]
      def published?
        data['published'] != false && (resource_options.publish_future_dated || published_before)
      end

      def published_at
        Time.parse(data['published']).in_time_zone if published_at?
      end

      def published_at?
        data['published'].present?
      end

      def published_before(time = Time.current)
        !published_at? || published_at <= time
      end
    end
  end
end
