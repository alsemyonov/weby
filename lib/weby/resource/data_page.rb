require 'weby/resource'

class Weby
  module Resource
    module DataPage
      def self.extended(base)
        base.extend Publishable
        base.extend Sortable
        base.extend Navigatable
        super(base)
      end
      # The title of the article, set from frontmatter.
      # @return [String]
      def title
        data['title'] || File.basename(path)
      end

      def canonical_url
        @canonical_url ||= URI.join(sitemap.url, url)
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

      # @return [String] dot.joined.string used for data lookups
      def data_lookup_path
        @data_lookup_path ||= url.to_s.split(%r(/+)).map(&:presence).compact.join('.')
      end

      def author
        data['author'] || resources_data['author']
      end

      def children
        @sorted_children ||= super.sort
      end

      def inspect
        '#<%s %s, %s, %s>' % ['Weby::Resource', path, url, data.to_json]
      end

      # @return [Weby]
      attr_accessor :resources_controller

      private

      delegate :data, :sitemap, :options, to: :resources_controller, prefix: :resources
    end
  end
end
