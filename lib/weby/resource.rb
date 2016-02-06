require 'weby'

class Weby
  module Resource
    extend ActiveSupport::Autoload

    autoload :DataPage
    autoload :Navigatable
    autoload :Pagination
    autoload :Publishable
    autoload :Schema
    autoload :Sortable
    autoload :Typify
    autoload :MetaData

    # Extends {Middleman::Sitemap::Resource} with all extensions provided by {Weby::Resource}
    def self.setup!
      require 'middleman-core/sitemap/resource'
      require 'weby/resource/meta_data'
      require 'weby/resource/navigatable'
      require 'weby/resource/pagination'
      require 'weby/resource/publishable'
      require 'weby/resource/schema'
      require 'weby/resource/sortable'
      require 'weby/resource/typify'
      Middleman::Sitemap::Resource.class_eval { include Resource }
    end

    # @return [Weby]
    def weby
      @resources_controller ||= Weby.instance
    end

    # @return [Hashie::Mash]
    def site_data
      weby.data
    end

    # @return [URI::Generic]
    def canonical_url
      @canonical_url ||= URI.join(sitemap.url, url)
    end

    # @return [String] dot.joined.string used for data lookups
    def data_lookup_path
      @data_lookup_path ||=
        begin
          url = self.url.to_s
          url = File.dirname(url) + '/' + File.basename(url, '.*')
          # url = url.gsub(/\.([a-z0-9]+)$/, '')
          url = url.split(%r(/+))
          url = url.map(&:presence).compact
          url.join('.')
        end
    end

    # @return [Hash]
    def author
      data['author'] || site_data['author']
    end

    # @return [String]
    def inspect
      '#<%s %s, %s, %s>' % ['Weby::Resource', path, url, data.to_json]
    end
  end
end
