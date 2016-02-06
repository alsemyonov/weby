require 'active_support'
require 'middleman-core'

require 'middleman-core/extension'

# Middleman extension that enhances sitemap and resources with methods every page resource deserves.
class Weby < ::Middleman::Extension
  extend ActiveSupport::Autoload

  autoload :Resource
  autoload :Helpers
  autoload :Sitemap

  option :publish_future_dated, nil, 'Whether pages with a date in the future should be considered published (development: true, production: false)'
  option :pry, true, 'Use Pry instead of IRB in Middleman console'
  option :enhance_slim, true, 'Customize Slim Engine to support shortcuts for role and itemprop'
  option :enhance_markdown, true, 'Customize Markdown renderer to support Abbreviations and list check boxes'

  class << self
    attr_accessor :instance
  end

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
    Weby.instance = self
  end

  def after_configuration
    Resource.setup!
    app.sitemap.extend Sitemap
  end

  # Enhances every resource with +Weby::Extensions+,
  # applies `published` rules
  # @param [<Middleman::Sitemap::Resource>] resources
  def manipulate_resource_list(resources)
    resources.map do |resource|
      next resource if resource.ignored?

      unless resource.published?
        if app.environment == :production
          app.ignore(resource.url)
        else
          resource.data['will_be_ignored_in_production'] = true
        end
      end

      resource
    end
  end

  delegate [:data, :set, :sitemap, :config] => :app

  helpers Helpers
end

require 'middleman-core/extensions'
Middleman::Extensions.register(:weby, Weby)
