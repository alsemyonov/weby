require 'weby/resource'
require 'active_support/core_ext/object/blank'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/object/try'

class Weby
  module Resource
    module Navigatable
      class Navigation
        # @param [Middleman::Sitemap::Resource] resource
        def initialize(resource)
          @resource = resource
        end

        delegate :url, :path, :title, :resource_type,
                 :resources_data, :locals, :paginated?, to: :@resource

        # @return [Hashie::Mash]
        def data
          return @data if defined?(@data)

          @data = @resource.data[:navigation]
          @data = (@data.nil? ? {} : { menu: @data }) unless @data.is_a?(Hash)

          @data.reverse_merge!(I18n.t(data_lookup_path, default: {}))
          @data.reverse_merge!(resources_data.data_for_path(data_lookup_path) || {})
          @data = Hashie::Mash.new(@data)
          @data
        end

        def label
          case resource_type
          when 'year'
            locals['year']
          when 'month'
            I18n.t('date.standalone_month_names')[locals['month']]
          when 'day'
            I18n.l(Date.new(locals['year'], locals['month'], locals['day']), format: '%d %B')
          else
            data.title || title
          end
        end

        # @return [Navigation]
        def parent_navigation
          @resource.try(:parent).try(:navigation)
        end

        # @return [Boolean]
        def parent_menu?
          (parent_navigation ? parent_navigation.menu? : true)
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
          navigatable? && !paginated? && parent_menu? && data[:menu]
        end

        # @return [String] Dot joined string `dot.joined.string` used for data lookups in `navigation.yml` and `I18n`
        def data_lookup_path
          ['navigation', @resource.data_lookup_path].compact.join('.').gsub(/\.+/, '.')
        end
      end

      def self.extended(base)
        base.extend(Typify)
        base.extend(Sortable)
      end

      delegate :menu?, :html?, :navigatable?, to: :navigation

      # Ignore a resource directly, without going through the whole
      # ignore filter stuff.
      # @return [void]
      def unignore!
        @ignored = false
      end

      # @return [Navigation]
      def navigation
        @navigation ||= Navigation.new(self)
      end
    end

    include Navigatable
  end
end
