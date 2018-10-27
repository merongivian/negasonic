require "bundler/gem_tasks"
Bundler.require
require 'opal/rspec/rake_task'

Opal::RSpec::RakeTask.new(:default) do |_, task|
  task.files = FileList['spec/**/*_spec.rb']
end
