# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name = 'weby'
  s.version = '0.0.1'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Alex Semyonov']
  s.email = ['al@semyonov.us']
  s.homepage = 'https://github.com/alsemyonov/weby'
  s.summary = 'Weby is a Middleman extension for better Web'
  # s.description = %q{A longer description of your extension}

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  # The version of middleman-core your extension depends on
  s.add_runtime_dependency('middleman-core', ['>= 4.0.0'])
  s.add_runtime_dependency('redcarpet', ['~> 3.3.4'])

  # Additional dependencies
  # s.add_runtime_dependency("gem-name", "gem-version")
end
