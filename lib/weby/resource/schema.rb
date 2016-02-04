require 'weby/resource'
require 'forwardable'

class Weby
  module Resource
    class Schema
      extend Forwardable

      TYPES = {
        'about' => 'http://schema.org/AboutPage',
        'contact' => 'http://schema.org/ContactPage',
        'article' => 'http://schema.org/BlogPosting',
        'post' => 'http://schema.org/BlogPosting',
        'year' => 'http://schema.org/CollectionPage',
        'month' => 'http://schema.org/CollectionPage',
        'day' => 'http://schema.org/CollectionPage',
        'tag' => 'http://schema.org/CollectionPage'
      }

      def self.lookup(name)
        TYPES[name.to_s] || 'http://schema.org/ItemPage'
      end

      # @param [Middleman::Sitemap::Resource] resource
      def initialize(resource)
        @resource = resource
      end

      attr_reader :resource
      delegate [:data] => :resource

      def type
        @type ||= self.class.lookup(resource.resource_type)
      end

      def to_html_attributes
        {itemtype: type, itemscope: true}
      end
    end

    def schema
      @schema ||= Schema.new(self)
    end
  end
end
