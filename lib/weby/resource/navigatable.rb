require 'weby/resource'
require 'forwardable'
require 'active_support/core_ext/object/blank'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/object/try'

class Weby
  module Resource
    module Navigatable
      class Navigation
        extend Forwardable

        # @param [Middleman::Sitemap::Resource] resource
        def initialize(resource)
          @resource = resource
        end

        # @return [Middleman::Sitemap::Resource]
        attr_reader :resource

        delegate [:url, :path, :title, :resources_data] => :resource

        # @return [Hashie::Mash]
        def data
          return @data if defined?(@data)

          @data = resource.data[:navigation]
          @data = (@data.nil? ? {} : { menu: @data }) unless @data.is_a?(Hash)

          @data.reverse_merge!(I18n.t(data_lookup_path, default: {}))
          @data.reverse_merge!(resources_data.data_for_path(data_lookup_path) || {})
          @data = Hashie::Mash.new(@data)
          @data
        end

        def parent
          resource.try(:parent).try(:navigation)
        end

        def humans?
          html?
        end

        # @return [Boolean] format is `HTML`
        def html?
          path =~ /\.html?$/
        end

        # @return [Boolean] visible to robots?
        def robots?
          !humans?
        end

        # @return [Boolean] visible to humans?
        def navigatable?
          humans?
        end

        # @return [Boolean] visible in menu?
        def menu?
          data[:menu] = title.present? unless data.key?(:menu)
          navigatable? && (parent ? parent.menu? : true) && data[:menu]
        end

        # @return [String] Dot joined string `dot.joined.string` used for data lookups in `navigation.yml` and `I18n`
        def data_lookup_path
          ['navigation', resource.data_lookup_path].compact.join('.').gsub(/\.+/, '.')
        end
      end

      def self.extended(base)
        base.extend(Typify)
        base.extend(Sortable)
      end

      def human_visible?
        html? && !tag?
      end

      def navigatable?
        human_visible?
      end

      def page_title
        data['page_title'] || data['title']
      end

      def navigation_title
        I18n.t("navigation.#{i18n_key}.title", default: page_title)
      end

      delegate :menu?, :html?, to: :navigation

      # @return [Navigation]
      def navigation
        @navigation ||= Navigation.new(self)
      end

      def navigation_data
        data['navigation'] ||= lookup(navigation_key, default: {}).tap do |data|
          data['menu'] = data['title'].present? unless data.key?('menu')
        end
      end

      def navigation_key
        @navigation_key ||= "navigation.#{i18n_key}".split(%r(\.)).map(&:presence).compact.join('.')
      end

      def i18n_key
        @i18n_key ||= url.to_s.split(%r(/+)).map(&:presence).compact.join('.')
      end

      def pageable?
        data['pageable']
      end

      def first_page?
        !locals['page_number'] || (locals['page_number'] == 1)
      end

      # @param [String] path
      # @param [Hash] options
      def lookup(path, options = {})
        lookup_path = "#{path}.#{i18n_key}"
        resources_data.data_for_path(lookup_path) ||
          I18n.t(lookup_path, options) ||
          data.data_for_path(path) ||
          options[:default]
      end

      # @param [String] path
      # @param [Hash] data
      # @return [Object]
      def lookup_data(path, data = self.data)
        steps = path.split('.')
        while data.is_a?(Hash) && steps.any
          data = data[steps.shift]
        end
        data
      end
    end
  end
end
