require 'weby'

class Weby
  module Resource
    extend ActiveSupport::Autoload

    autoload :DataPage
    autoload :Navigatable
    autoload :Publishable
    autoload :Sortable
    autoload :Typify

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
