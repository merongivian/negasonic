module Negasonic
  module DSL
    def part(instrument:, &block)
      the_instrument = Negasonic::Instrument.find(instrument)

      the_loop = Negasonic::LoopedEvent::Part.new(the_instrument.input_node)
      the_loop.instance_eval(&block)
      the_loop.start
    end

    def pattern(instrument:, type:, notes:)
      the_instrument = Negasonic::Instrument.find(instrument)

      Negasonic::LoopedEvent::Pattern.new(the_instrument.input_node, notes)
                                     .start(type)
    end

    def with_instrument(name, synth:, volume: nil, &block)
      synth_node = Negasonic::Instrument::Synth.send(synth, { volume: volume })
      instrument = Negasonic::Instrument.find(name) ||
                   Negasonic::Instrument.add(name)

      old_cycles = instrument.cycles
      instrument.reload

      instrument.base_input_node = synth_node
      instrument.instance_eval(&block) if block_given?

      if instrument.effects_changed?
        instrument.connect_new_effects
      end

      Negasonic.schedule_next_cycle do
        if instrument.effects_changed?
          instrument.connect_synth_to_new_effects
        end
        old_cycles.each(&:dispose)
        instrument.cycles.each(&:start)
      end
    end
  end
end
