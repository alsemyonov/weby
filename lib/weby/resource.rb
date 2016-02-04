require 'weby'

class Weby
  module Resource
    extend ActiveSupport::Autoload

    autoload :DataPage
    autoload :Navigatable
    autoload :Publishable
    autoload :Schema
    autoload :Sortable
    autoload :Typify

    # Extends {Middleman::Sitemap::Resource} with all extensions provided by {Weby::Resource}
    def self.setup!
      require 'middleman-core/sitemap/resource'
      require 'weby/resource/data_page'
      require 'weby/resource/navigatable'
      require 'weby/resource/publishable'
      require 'weby/resource/schema'
      require 'weby/resource/sortable'
      require 'weby/resource/typify'
      Middleman::Sitemap::Resource.class_eval do
        include Resource
      end
    end
  end
end
