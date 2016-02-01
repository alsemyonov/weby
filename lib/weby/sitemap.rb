require 'weby'

class Weby
  module Sitemap
    extend ActiveSupport::Concern

    # @return [<Middleman::Sitemap::Resource>]
    def roots
      resources.select { |resource| !resource.parent }
    end

    # @return [Middleman::Sitemap::Resource]
    def root
      roots.first
    end
  end
end
