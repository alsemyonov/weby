require 'active_support'
require 'middleman-core'

# Extension namespace
class Weby < ::Middleman::Extension
  extend ActiveSupport::Autoload

  autoload :Extensions
  autoload :Helpers

  option :publish_future_dated, false, 'Whether pages with a date in the future should be considered published'

  def initialize(app, options_hash = {}, &block)
    # Call super to build options from the options_hash
    super

    # Require libraries only when activated
    # require 'necessary/library'

    # set up your extension
    # puts options.my_option
  end

  def after_configuration
    # Do something
  end

  # A Sitemap Manipulator
  def manipulate_resource_list(resources)
    resources.each do |resource|
      enhance_resource(resource)
    end
  end

  def enhance_resource(resource)
    return unless resource.respond_to?(:data)
    resource.extend Extensions::DataPage
    resource.resource_controller = self
  end

  helpers Helpers
end

# Register extensions which can be activated
# Make sure we have the version of Middleman we expect
# Name param may be omitted, it will default to underscored
# version of class name

Middleman::Extensions.register(:weby, Weby)
