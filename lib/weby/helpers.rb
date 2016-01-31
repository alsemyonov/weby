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
  end
end
