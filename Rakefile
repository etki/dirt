begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |task|
    task.pattern = 'test/spec/**/*.spec.rb'
  end

  task :default => :spec
  task :test => :spec
end