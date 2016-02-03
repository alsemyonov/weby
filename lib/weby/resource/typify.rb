require 'weby/resource'

class Weby
  module Resource
    module Typify
      def page_type
        metadata[:locals]['page_type'] ||= data['page_type'] ||
          article? ? 'article' : 'resource'
      end

      if defined?(Middleman::Blog)
        # @return [Boolean]
        def article?
          is_a?(Middleman::Blog::BlogArticle)
        end
      else
        # @return [Boolean]
        def article?
          false
        end
      end

      %w(tag year month day).each do |method|
        define_method("#{method}?") { page_type == method }
      end
    end
  end
end
