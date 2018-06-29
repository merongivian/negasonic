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

    attr_reader :name, :effects_set
    attr_writer :input_node

    def initialize(name)
      @name = name
      @cycles = []
    end

    def dispose_cycles
      @cycles.each(&:dispose)
      @cycles = []
    end

    def cycle(&block)
      the_cycle = Negasonic::LoopedEvent::Sequence.new(@input_node)
      the_cycle.instance_eval(&block)
      the_cycle.start
      @cycles << the_cycle
    end
  end
end
