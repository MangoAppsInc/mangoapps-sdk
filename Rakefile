# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

# RSpec task
RSpec::Core::RakeTask.new(:spec)

# RuboCop task
RuboCop::RakeTask.new

# Default task
task default: [:spec, :rubocop]

# Build task
task :build do
  system("gem build mangoapps-sdk.gemspec")
end

# Install task
task :install => :build do
  system("gem install mangoapps-sdk-*.gem")
end

# Clean task
task :clean do
  FileUtils.rm_f(Dir["mangoapps-sdk-*.gem"])
  FileUtils.rm_rf("coverage")
  FileUtils.rm_f(".rspec_status")
end

# Test with coverage
task :coverage do
  ENV["COVERAGE"] = "true"
  Rake::Task[:spec].invoke
end

# Release task
task :release => [:clean, :spec, :rubocop, :build] do
  puts "Ready for release! Run 'gem push mangoapps-sdk-*.gem' to publish."
end
