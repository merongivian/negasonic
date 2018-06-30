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

    attr_reader :name, :cycles
    attr_writer :input_node

    def initialize(name)
      @name = name
      @cycles = []
      @input_nodes = []
      @used_input_nodes = 0
    end

    def reload
      dispose_cycles
      @used_input_nodes = 0
    end

    def dispose_cycles
      @cycles.each(&:dispose)
      @cycles = []
    end

    def base_input_node=(new_base_input_node)
      if @base_input_node != new_base_input_node
        @base_input_node = new_base_input_node
        @input_nodes = [@base_input_node]
      else
        new_base_input_node.dispose
      end
    end

    def cycle(&block)
      cycle_input_node =
        if @input_nodes[@used_input_nodes]
          @input_nodes[@used_input_nodes]
        else
          @base_input_node.clone.tap do |node|
            @input_nodes << node
          end
        end

      the_cycle = Negasonic::LoopedEvent::Sequence.new(cycle_input_node)
      the_cycle.instance_eval(&block)
      the_cycle.start
      @used_input_nodes += 1
      @cycles << the_cycle
    end
  end
end
