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
      @loops = []
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
  end
end
