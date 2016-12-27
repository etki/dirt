Gem::Specification.new do |s|
  s.name = 'semble'
  s.version  = '0.1.0'
  s.platform = Gem::Platform::RUBY
  s.summary  = 'Basic tool to maintain multi-version Docker projects'
  s.authors  = ['Etki']
  s.files    = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
  s.executables = 'semble'
  s.homepage = 'https://github.com/etki/semble'
  s.license  = 'MIT'
  s.add_runtime_dependency 'liquid', '~> 4.0'
  s.add_runtime_dependency 'gli', '~> 2.0'
  s.add_runtime_dependency 'semantic', '~> 1.5'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rake', '< 11.0' # last_comment RSpec issue
end