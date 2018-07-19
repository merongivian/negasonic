require 'negasonic/notes_generation/dsl'
require 'negasonic/time'

module Negasonic
  module LoopedEvent
    class Sequence
      attr_reader :synth

      include Negasonic::NotesGeneration::DSL

      def initialize(synth, segments = [], humanize: false, probability: 1, expand: 1)
        @synth = synth
        @segments = segments
        @humanize = humanize
        @probability = probability
        @number_of_cycles = expand
      end

      def start
        do_start(segment_duration) do |time, note|
          @synth.trigger_attack_release(note, segment_duration, time)
        end
      end

      def dispose
        @tone_sequence && @tone_sequence.dispose
      end

      def play(*notes)
        @segments << LoopedEvent.to_tone_notes(notes.flatten)
      end

      private

      def do_start(duration, &block)
        @tone_sequence =
          Tone::Event::Sequence.new(@segments, duration, &block).tap do |sequence|
            sequence.humanize = @humanize
            sequence.probability = @probability
          end

        LoopedEvent.start(@tone_sequence)
      end

      def segment_duration
        Negasonic::Time::Segments.new(@segments, @number_of_cycles)
                                 .duration
      end
    end
  end
end
