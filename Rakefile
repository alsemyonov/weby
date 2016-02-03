require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/clean'

begin
  require 'rspec/core/rake_task'

  desc 'Run specs'
  RSpec::Core::RakeTask.new(:spec) do |t|
    ENV['TEST'] = 'true'

    t.verbose = false
  end
  task test: :spec
rescue LoadError
  task(:spec) { abort 'Bundle with test group: `bundle install --with test`' }
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:cucumber, 'Run features that should pass') do |t|
    ENV['TEST'] = 'true'

    t.cucumber_opts = '--color --tags ~@wip --strict'
  end
  task test: :cucumber
rescue LoadError
  task(:cucumber) { abort 'Bundle with test group: `bundle install --with test`' }
end

begin
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task spec: 'coveralls:push'
  task cucumber: 'coveralls:push'
rescue LoadError
  namespace(:coveralls) { task(:push) { abort 'Bundle with test group: `bundle install --with test`' } }
end

begin
  require 'yard'
  require 'cucumber'
  YARD::Rake::YardocTask.new(:doc)
rescue LoadError => e
  task(:doc) { abort 'Bundle with development group: `bundle install --with development`' }
end

task default: [:test, :doc]
