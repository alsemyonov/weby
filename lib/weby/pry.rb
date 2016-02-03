require 'weby'

require 'middleman-cli'
require 'middleman-cli/console'

module Middleman
  module Pry
    # Interact with +context+ in Pry console
    def interact_using_pry_with(context)
      require 'pry'
      context.pry
    rescue LoadError
      STDERR.puts 'Cannot load Pry, add it to Gemfile, use IRB otherwise:'
      Cli::Console.interact_using_irb_with(context)
    end
  end

  module Cli
    # Overrides the built-in +Console.interact_with+ method with Pry
    class Console
      extend Middleman::Pry

      class << self
        alias_method :interact_using_irb_with, :interact_with
        alias_method :interact_with, :interact_using_pry_with
      end
    end
  end
end
