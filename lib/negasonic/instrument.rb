require 'negasonic/instrument/effects_set'
require 'negasonic/instrument/synth'
require 'negasonic/dsl'

module Negasonic
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

    attr_reader :input_node, :name, :effects_set

    def initialize(name)
      @name = name
      @nodes = []
      @loops = []
      @effects_set = EffectsSet.new
    end

    def effects(&block)
      @effects_set.reload
      @effects_set.instance_eval(&block)
    end

    def dispose_loops
      @loops.each(&:dispose)
      @loops = []
    end

    def loop(&block)
      the_loop = Negasonic::LoopedEvent::Sequence.new(@input_node)
      the_loop.instance_eval(&block)
      the_loop.start
      @loops << the_loop
    end

    def connect_nodes(new_synth)
      new_nodes = [new_synth, @effects_set.nodes].flatten

      if @nodes != new_nodes
        @input_node = new_synth
        @input_node.chain(*@effects_set.nodes)

        old_nodes = @nodes
        @nodes = new_nodes

        Tone::Transport.schedule_once('+1m') do |time|
          old_nodes.each(&:dispose)
        end
      else
        new_synth.dispose
      end
    end
  end
end
