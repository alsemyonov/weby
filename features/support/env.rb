PROJECT_ROOT_PATH = File.expand_path('../../..', __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT_PATH, 'lib')

ENV['TEST'] = 'true'

require 'simplecov'
SimpleCov.start do
  add_filter '/features/'
end

require 'coveralls'
Coveralls.wear!

require 'middleman-core'
require 'middleman-core/step_definitions'
require 'weby'
