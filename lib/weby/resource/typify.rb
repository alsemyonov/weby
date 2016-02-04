require 'weby/resource'

class Weby
  module Resource
    module Typify
      def resource_type
        metadata[:locals]['type'] ||= data['type'] ||
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
        define_method("#{method}?") { resource_type == method }
      end
    end

    include Typify
  end
end
