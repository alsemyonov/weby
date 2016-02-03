require 'weby'

class Weby
  module Markdown
    extend ActiveSupport::Autoload

    autoload :Abbreviations
    autoload :ListCheckBoxes
    autoload :Renderer

    def enhance_markdown
      require 'redcarpet'
      config[:markdown_engine] = :redcarpet
      config[:markdown] ||= {}
      config[:markdown].merge!({
        autolink: true,
        fenced_code_blocks: true,
        footnotes: true,
        strikethrough: true,
        highlight: true,
        superscript: true,
        tables: true,
        underline: true,
        smartypants: true,
        with_toc_data: true,
        no_intra_emphasis: true,
        renderer: Renderer,
      })
      config[:slim] ||= {}
      config[:slim][:markdown] = config[:markdown]
    end
  end

  include Markdown
end
