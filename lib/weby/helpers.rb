require 'weby'

class Weby
  module Helpers
    # @param [String] text
    def title(text)
      content_for(:title) { text }
      text
    end

    # @param [String] text
    # @return [String, nil]
    def head_title(text = nil)
      yield_content(:title).presence || current_resource.data['title'].presence || data.site['title'] || text
    end

    def inspect(object)
      content_tag(:code, escape_html(object.inspect))
    end

    def debug(object)
      # content_tag(:pre, content_tag(:code, escape_html(object.to_yaml)))
      content_tag(:pre, inspect(object))
    end
  end
end
