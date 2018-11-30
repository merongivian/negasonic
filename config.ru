require 'bundler'
Bundler.require

require 'opal/rspec'

sprockets_env = Opal::RSpec::SprocketsEnvironment.new(spec_pattern='spec/**/*_spec.rb')
run Opal::Server.new(sprockets: sprockets_env) { |s|
  s.main = 'opal/rspec/sprockets_runner'
  s.append_path 'spec'
  sprockets_env.add_spec_paths_to_sprockets
  s.debug = false
}
