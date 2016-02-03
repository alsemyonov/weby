source 'https://rubygems.org/'

# Specify your gem's dependencies in weby.gemspec
gemspec

group :development do
  gem 'middleman-cli', git: 'https://github.com/middleman/middleman.git', branch: 'master'
  gem 'middleman-core', git: 'https://github.com/middleman/middleman.git', branch: 'master'
  gem 'slim'

  platforms :ruby do
    gem 'redcarpet', '>= 3.3'
  end

  # Build and doc tools
  gem 'rake', '~> 10.3', require: false
  gem 'rdoc', '~> 4.2.1', require: false
  gem 'yard', '~> 0.8', require: false
  gem 'pry', '~> 0.10', require: false
end

group :test do
  # Test tools
  gem 'cucumber', '~> 2.0', require: false
  gem 'aruba', '~> 0.7.4', require: false
  gem 'rspec', '~> 3.0', require: false
  gem 'rspec-its', '~> 1.2.0', require: false

  gem 'timecop', '~> 0.6.3'
  gem 'nokogiri'
  gem 'kramdown'

  # Code Quality
  gem 'rubocop', '~> 0.24', require: false
  gem 'simplecov', '~> 0.9', require: false
  gem 'coveralls', '~> 0.8', require: false
  gem 'codeclimate-test-reporter', '~> 0.3', require: false, group: :test
end
