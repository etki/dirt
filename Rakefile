require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = 'test/spec/**/*.spec.rb'
  task.rspec_opts = "--require #{__dir__}/test/helper/general"
end

task :default => :spec
task :test => :spec
