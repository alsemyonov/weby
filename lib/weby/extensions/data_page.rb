require 'weby/extensions'

class Weby
  module Extensions
    module DataPage
      # The title of the article, set from frontmatter.
      # @return [String]
      def title
        data['title'] || File.basename(path)
      end

      def full_url
        URI.join(sitemap.url, url)
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
        meta << { name: :generator, content: "Weby/#{Weby.version}" }
        meta << { name: :environment, content: resources_controller.app.environment }
        meta
      end

      def author
        data['author'] || resources_data['author']
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
        data['is_published'] ||= parent_published? && data_published?
      end

      # @return [Boolean]
      def parent_published?
        return data['parent_published'] if data.key?('parent_published')
        parent = self.parent
        return data['parent_published'] = :no_parent unless parent
        parent = enhance_resource(parent)
        data['parent_published'] = parent.respond_to?(:published?) ? parent.published? : !parent.ignored?
      end

      # @return [Boolean, Symbol]
      def data_published?
        return data['published_by_data'] if data.key?('published_by_data')
        return data['published_by_data'] = :no_data unless respond_to?(:data)
        data['published_by_data'] ||= data['published'] != false && published_by_date?
      end

      # @return [Boolean]
      def published_by_date?
        @published_by_date ||= options_published? || already_published?
      end

      # @return [Boolean]
      def options_published?
        resources_options.publish_future_dated
      end

      # @return [Time]
      def published_at
        data['published_at'] ||= published_at? || Time.current
      end

      # @return [Boolean, Time]
      def published_at?
        (data['published'].is_a?(Date) || data['published'].is_a?(Time)) && data['published']
      end

      # @param [Time] time
      # @return [Boolean]
      def published_before(time = Time.current)
        !published_at? || published_at <= time
      end

      # @return [Boolean]
      def already_published?
        data['already_published'] ||= published_before
      end

      def parent
        @enhanced_parent ||= enhance_resource(super)
      end

      def inspect
        '#<%s %s, %s, %s>' % ['Weby::Resource', path, url, data.to_json]
      end

      # @return [Weby]
      attr_accessor :resources_controller

      private

      delegate :data, :options, to: :resources_controller, prefix: :resources
      delegate :enhance_resource, to: :resources_controller
    end
  end
end
