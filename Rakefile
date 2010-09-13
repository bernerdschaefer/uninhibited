require "rake/clean"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

load 'tasks/docs.rake'

task :default => [:spec]
