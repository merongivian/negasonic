if RUBY_ENGINE == 'opal'
  require 'tone'
  require 'negasonic/instrument'
  require 'negasonic/looped_event'
  require 'negasonic/notes_generation'
  require 'negasonic/dsl'
  require 'negasonic/time'

  extend Negasonic::DSL

  module Negasonic
    @default_instrument =
      Instrument.add('default').tap do |instrument|
        instrument.base_input_node = Instrument::Synth.simple
        instrument.used = false
      end

    class << self
      attr_reader :default_instrument
    end
  end

  ############
  # DEFAULTS #
  ############

  bpm(800)
else
  require 'opal'

  Opal.append_path File.expand_path('../', __FILE__).untaint
end
