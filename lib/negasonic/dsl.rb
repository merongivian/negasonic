module Negasonic
  module DSL
    def part(instrument:, &block)
      the_instrument = Negasonic::Instrument.find(instrument)

      the_loop = Negasonic::LoopedEvent::Part.new(the_instrument.input_node)
      the_loop.instance_eval(&block)
      the_loop.start
    end

    def loop(instrument:, &block)
      the_instrument = Negasonic::Instrument.find(instrument)

      the_loop = Negasonic::LoopedEvent::Sequence.new(the_instrument.input_node)
      the_loop.instance_eval(&block)
      the_loop.start
    end

    def pattern(instrument:, type:, notes:)
      the_instrument = Negasonic::Instrument.find(instrument)

      Negasonic::LoopedEvent::Pattern.new(the_instrument.input_node, notes)
                                     .start(type)
    end

    def instrument(name, synth:, volume: nil, &block)
      instrument = Negasonic::Instrument.find(name) ||
                   Negasonic::Instrument.add(name)

      synth_node = Negasonic::Instrument::Synth.send(synth, { volume: volume })

      instrument.tap do |i|
        i.instance_eval(&block)
        i.connect_nodes(synth_node)
      end
    end
  end
end
