require 'weby'

require 'middleman-cli'
require 'middleman-cli/console'
class Middleman::Cli::Console
  singleton_class.class_eval do
    alias_method :interact_using_irb_with, :interact_with

    # Override the built-in +interact_with+ method
    def interact_with(context)
      require 'pry'
      context.pry
    rescue LoadError
      interact_using_irb_with(context)
    end
  end
end
