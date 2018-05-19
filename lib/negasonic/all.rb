module Kernel
  def part(instrument:, &block)
    the_instrument = NegaSonic::Instrument.find(instrument)

    the_loop = NegaSonic::LoopedEvent::Part.new(the_instrument.input_node)
    the_loop.instance_eval(&block)
    the_loop.start
  end

  def sequence(instrument:, interval: , &block)
    the_instrument = NegaSonic::Instrument.find(instrument)

    the_loop = NegaSonic::LoopedEvent::Sequence.new(the_instrument.input_node)
    the_loop.instance_eval(&block)
    the_loop.start(interval)
  end

  def pattern(instrument:, interval:, type:, notes:)
    the_instrument = NegaSonic::Instrument.find(instrument)

    NegaSonic::LoopedEvent::Pattern.new(the_instrument.input_node, notes)
                                   .start(interval, type)
  end

  def instrument(name, synth:, volume: nil, &block)
    instrument = NegaSonic::Instrument.find(name) ||
                 NegaSonic::Instrument.add(name)

    synth_node = NegaSonic::Synth.send(synth, { volume: volume })

    instrument.tap do |i|
      i.instance_eval(&block)
      i.connect_nodes(synth_node)
    end
  end
end

module NegaSonic
  module Synth
    class << self
      def simple(**opts)
        Tone::Synth::Simple.new(**opts)
      end

      def membrane(**opts)
        Tone::Synth::Membrane.new(**opts)
      end

      def am(**opts)
        Tone::Synth::AM.new(**opts)
      end

      def fm(**opts)
        Tone::Synth::FM.new(**opts)
      end

      def duo(**opts)
        Tone::Synth::Duo.new(**opts)
      end

      def mono(**opts)
        Tone::Synth::Mono.new(**opts)
      end

      def pluck(**opts)
        Tone::Synth::Pluck.new(**opts)
      end

      def poly(**opts)
        Tone::Synth::Poly.new(**opts)
      end
    end
  end

  class Instrument
    @all = []

    class << self
      attr_accessor :all

      def find(name)
        @all.find do |instrument|
          instrument.name == name
        end
      end

      def add(name)
        new(name).tap do |instrument|
          @all << instrument
        end
      end
    end

    attr_reader :input_node, :name

    def initialize(name)
      @name = name
      @nodes = []
      @effects_dsl = EffectsDSL.new
    end

    def effects(&block)
      @effects_dsl.reload
      @effects_dsl.instance_eval(&block)
    end

    def connect_nodes(new_synth)
      new_nodes = [new_synth, @effects_dsl.nodes].flatten

      if @nodes != new_nodes
        @input_node = new_synth
        @input_node.chain(*@effects_dsl.nodes)

        old_nodes = @nodes
        @nodes = new_nodes

        Tone::Transport.schedule_after(1) do |time|
          old_nodes.each(&:dispose)
        end
      end
    end
  end

  class EffectsDSL
    attr_reader :nodes

    def initialize
      @nodes = []
    end

    def reload
      @nodes = []
    end

    def vibrato(**opts)
      @nodes << Tone::Effect::Vibrato.new(**opts)
    end

    def distortion(**opts)
      @nodes << Tone::Effect::Distortion.new(**opts)
    end

    def chorus(**opts)
      @nodes << Tone::Effect::Chorus.new(**opts)
    end

    def tremolo(**opts)
      @nodes << Tone::Effect::Tremolo.new(**opts)
    end

    def feedback_delay(**opts)
      @nodes << Tone::Effect::FeedbackDelay.new(**opts)
    end

    def freeverb(**opts)
      @nodes << Tone::Effect::Freeverb.new(**opts)
    end

    def jc_reverb(**opts)
      @nodes << Tone::Effect::JCReverb.new(**opts)
    end

    def phaser(**opts)
      @nodes << Tone::Effect::Phaser.new(**opts)
    end

    def ping_pong_delay(**opts)
      @nodes << Tone::Effect::PingPongDelay.new(**opts)
    end
  end

  module LoopedEvent
    @events = []

    class << self
      attr_accessor :events

      def dispose_all
        @events.each(&:dispose)
        @events = []
      end

      def start(looped_element)
        looped_element.start(0)
        looped_element.loop = true
        @events << looped_element
      end
    end

    class Part
      def initialize(synth)
        @synth = synth
        @definitions = []
      end

      def start
        do_start do |time, event|
          @synth.trigger_attack_release(event.JS['note'], event.JS['duration'], time)
        end
      end

      def play(note, time, duration)
        @definitions << { note: note, time: time, duration: duration }
      end

      private

      def do_start(&block)
        LoopedEvent.start(Tone::Event::Part.new @definitions, &block)
      end
    end

    class Sequence
      def initialize(synth, segments = [])
        @synth = synth
        @segments = segments
      end

      def start(duration)
        do_start(duration) do |time, note|
          @synth.trigger_attack_release(note, duration, time)
        end
      end

      def play(*notes)
        @segments << notes
      end

      private

      def do_start(duration, &block)
        LoopedEvent.start(Tone::Event::Sequence.new @segments, duration, &block)
      end
    end

    class Pattern
      TYPES = {
        random: 'random',
        random_walk: 'randomWalk',
        random_once: 'randomOnce',
        up: 'up',
        down: 'down',
        up_down: 'upDown',
        down_up: 'downUp',
        alternate_up: 'alternateUp',
        alternate_down: 'alternateDown'
      }

      def initialize(synth, notes = [])
        @synth = synth
        @notes = notes
      end

      def start(duration, type)
        raise 'invalid pattern type' unless TYPES.keys.include?(type)

        do_start(duration, TYPES[type]) do |time, note|
          @synth.trigger_attack_release(note, duration, time)
        end
      end

      private

      def do_start(duration, type, &block)
        pattern = Tone::Event::Pattern.new(@notes, type, &block)
        pattern.interval = duration
        LoopedEvent.start(pattern)
      end
    end
  end
end
