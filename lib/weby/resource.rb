require 'weby'

class Weby
  module Resource
    extend ActiveSupport::Autoload

    autoload :DataPage
    autoload :Navigatable
    autoload :Publishable
    autoload :Sortable
    autoload :Typify

    # Extends {Middleman::Sitemap::Resource} with all extensions provided by {Weby::Resource}
    def self.setup!
      require 'middleman-core/sitemap/resource'
      Middleman::Sitemap::Resource.class_eval do
        include DataPage
        include Publishable
        include Sortable
        include Navigatable
      end
    end
  end
end
