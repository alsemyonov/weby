require 'weby'

class Weby
  module Sitemap
    extend ActiveSupport::Concern

    # @return [<Middleman::Sitemap::Resource>]
    def roots
      resources.select { |resource| !resource.parent }.sort_by(&Weby::Sitemap.children_orderer)
    end

    # @return [Middleman::Sitemap::Resource]
    def root
      roots.first
    end

    def self.children_orderer
      -> (item) { [item.data.position.to_i, item.published_at.to_i, item.url.to_s] }
    end
  end
end
