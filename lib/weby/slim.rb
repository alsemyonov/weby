require 'weby'

class Weby
  module Slim
    extend ActiveSupport::Autoload

    autoload :Abbreviations
    autoload :ListCheckBoxes
    autoload :Renderer

    def enhance_slim
      require 'slim'
      config[:slim] ||= {}
      config[:slim].merge!(
        format: :html,
        pretty: app.environment == :development,
        shortcut: {
          '#' => { attr: 'id' },
          '.' => { attr: 'class' },
          '&' => { attr: 'itemprop' },
          '%' => { attr: 'rel' },
          '@' => { attr: 'role' }
        },
        merge_attrs: {
          'class' => ' ',
          'itemprop' => ' ',
          'rel' => ' '
        }
      )
    end
  end

  include Slim
end
