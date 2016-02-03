require 'weby/markdown'
require 'redcarpet'

class Weby
  module Markdown
    class Renderer < Redcarpet::Render::SmartyHTML
      include Abbreviations
      include ListCheckBoxes
    end
  end
end
