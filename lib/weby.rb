require 'active_support'
require 'middleman-core'

# Extension namespace
require 'middleman-core/extension'
class Weby < ::Middleman::Extension
  extend ActiveSupport::Autoload

  autoload :Extensions
  autoload :Helpers
  autoload :Sitemap

  option :publish_future_dated, false, 'Whether pages with a date in the future should be considered published (development: true, production: false)'

  def self.version
    Gem.loaded_specs['weby'].version
  end

  def initialize(app, options_hash = {}, &block)
    # Call super to build options from the options_hash
    super

    # Require libraries only when activated
    # require 'necessary/library'

    # Publish future dated pages in development environment
    options[:publish_future_dated] = (app.environment == :development) if options[:publish_future_dated] == nil

    app.sitemap.extend Sitemap
  end

  def after_configuration
    # Do something
  end

  # A Sitemap Manipulator
  # @param [<Middleman::Sitemap::Resource>] resource
  def manipulate_resource_list(resources)
    resources.map do |resource|
      next resource if resource.ignored?
      resource = enhance_resource(resource)

      case app.environment
      when :production
        app.ignore(resource.path) unless resource.published?
      end

      resource
    end
  end

  # @param [Middleman::Sitemap::Resource] resource
  def enhance_resource(resource)
    return resource unless resource.is_a?(Middleman::Sitemap::Resource)
    return resource if resource.is_a?(Extensions::DataPage)

    resource.extend Extensions::DataPage
    resource.resources_controller = self

    resource
  end

  delegate data: :app

  helpers Helpers
end

require 'middleman-core/extensions'
Middleman::Extensions.register(:weby, Weby)
