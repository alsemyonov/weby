require 'active_support'
require 'middleman-core'

require 'middleman-core/extension'

# Middleman extension that enhances sitemap and resources with methods every page resource deserves.
class Weby < ::Middleman::Extension
  extend ActiveSupport::Autoload

  autoload :Extensions
  autoload :Resource
  autoload :Helpers
  autoload :Sitemap

  option :publish_future_dated, false, 'Whether pages with a date in the future should be considered published (development: true, production: false)'
  option :pry, true, 'Use Pry instead of IRB in Middleman console'
  option :enhance_slim, true, 'Customize Slim Engine to support shortcuts for role and itemprop'
  option :enhance_markdown, true, 'Customize Markdown renderer to support Abbreviations and list check boxes'

  # @return [Gem::Version]
  def self.version
    Gem.loaded_specs['weby'].version
  end

  # @param [Middleman::Application] app
  # @param [Hash] options_hash
  # @param [Proc] block
  def initialize(app, options_hash = {}, &block)
    # Call super to build options from the options_hash
    super

    # Require libraries only when activated
    require 'weby/pry' if options[:pry]

    if options[:enhance_slim]
      require 'weby/slim'
      enhance_slim
    end

    if options[:enhance_markdown]
      require 'weby/markdown'
      enhance_markdown
    end

    # Publish future dated pages in development environment
    options[:publish_future_dated] = (app.environment == :development) if options[:publish_future_dated] == nil

    app.sitemap.extend Sitemap
  end

  def after_configuration
    app.sitemap.extend Sitemap
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

  delegate [:data, :set, :sitemap, :config] => :app

  helpers Helpers
end

require 'middleman-core/extensions'
Middleman::Extensions.register(:weby, Weby)
