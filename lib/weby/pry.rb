require 'weby'

require 'middleman-cli'
require 'middleman-cli/console'
module Middleman
  module Pry
  end

  class Cli::Console
    singleton_class.class_eval do
      alias_method :interact_using_irb_with, :interact_with

      # Override the built-in +interact_with+ method
      def interact_with(context)
        require 'pry'
        context.pry
      rescue LoadError
        STDERR.puts 'Cannot load Pry, add it to Gemfile, use IRB otherwise:'
        interact_using_irb_with(context)
      end
    end
  end
end
