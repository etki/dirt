require 'coveralls'
require 'simplecov'
require 'pathname'

root = Pathname.new(__dir__).dirname.dirname

SimpleCov.formatters = [
    Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start do
  track_files "#{root}/lib/**/*.rb"
  coverage_dir "#{root}/report/coverage"
  add_filter "#{root}/test"
end