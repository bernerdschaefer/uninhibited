require "rake/clean"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.spec_opts = ['--format=Uninhibited::Formatter']
  spec.pattern = "spec/**/*_spec.rb"
end

load 'tasks/docs.rake'

task :default => [:spec]
