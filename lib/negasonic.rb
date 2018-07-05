if RUBY_ENGINE == 'opal'
  require 'tone'
  require 'negasonic/instrument'
  require 'negasonic/looped_event'
  require 'negasonic/notes_generation'
  require 'negasonic/dsl'

  extend Negasonic::DSL

  module Negasonic
    NOTATION = "n"
    @default_instrument =
      Instrument.add('default').tap do |instrument|
        instrument.base_input_node = Instrument::Synth.simple
        instrument.used = true
      end

    class << self
      attr_reader :default_instrument

      def schedule_next_cycle(&block)
        Tone::Transport.schedule_once(
          Tone::Transport.next_subdivision("1#{NOTATION}"),
          &block
        )
      end
    end
  end
else
  require 'opal'

  Opal.append_path File.expand_path('../', __FILE__).untaint
end
