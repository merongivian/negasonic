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

      def set_all_to_not_used
        @all.select { |i| i.name != 'default' }
            .each { |i| i.used = false }
      end

      def all_not_used
        @all.select do |i|
          i.name != 'default' && !i.used
        end
      end
    end

    attr_reader :name, :cycles, :stored_cycles
    attr_accessor :used

    def initialize(name)
      @name = name
      @cycles = []
      @input_nodes = []
      @used_input_nodes = 1
      @effect_nodes = []
      @used = false
      store_current_cycles
    end

    def reload
      @used_input_nodes = 1
      @cycles = [create_default_cycle]
    end

    def store_current_cycles
      @stored_cycles = @cycles
    end

    def dispose_stored_cycles
      @stored_cycles.each(&:dispose)
    end

    def kill_current_cycles
      @cycles.each(&:dispose)
      @cycles = []
    end

    def start_current_cycles
      @cycles.each(&:start)
    end

    def base_input_node=(new_base_input_node)
      if @base_input_node != new_base_input_node
        @base_input_node = new_base_input_node

        connect_to_effects(@base_input_node, @effect_nodes)
        @input_nodes = [@base_input_node]
      else
        new_base_input_node.dispose
      end
    end

    def effects_changed?(effects_set)
      @effect_nodes != effects_set.nodes
    end

    def swap_effects(effects_set)
      old_effect_nodes = @effect_nodes
      new_effect_nodes = effects_set.nodes

      @effect_nodes = new_effect_nodes

      old_effect_nodes.each(&:dispose)
    end

    def connect_input_nodes_to_effects
      @input_nodes.each do |input_node|
        connect_to_effects(input_node, @effect_nodes)
      end
    end

    def connect_new_effects
      @effects_set.chain
    end

    def connect_to_effects(input, effects)
      if effects.any?
        input.connect(effects.first)
      else
        input.to_master
      end
    end

    def create_default_cycle
      Negasonic::LoopedEvent::Sequence.new(@base_input_node)
    end

    #########
    ## DSL ##
    #########

    def cycle(**opts, &block)
      cycle_input_node =
        if @input_nodes[@used_input_nodes]
          @input_nodes[@used_input_nodes]
        else
          @base_input_node.clone.tap do |node|
            @input_nodes << node
          end
        end

      Negasonic::LoopedEvent::Sequence.new(cycle_input_node, **opts).tap do |the_cycle|
        the_cycle.instance_eval(&block)
        @used_input_nodes += 1
        @cycles << the_cycle
      end
    end

    def play(*notes)
      @cycles[0].play(*notes)
    end
  end
end
