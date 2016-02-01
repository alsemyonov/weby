require 'bundler'
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber, 'Run features that should pass') do |t|
  ENV['TEST'] = 'true'

  t.cucumber_opts = '--color --tags ~@wip --strict'
end

require 'rake/clean'

task test: ['cucumber']


begin
  require 'yard'
  require 'cucumber'
  YARD::Rake::YardocTask.new(:doc)
rescue LoadError => e
  task(:doc) do
    puts e.inspect
    abort 'YARD is not available. In order to run yardoc, you must bundle with development group'
  end
end

task default: :test
