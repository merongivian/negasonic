module Negasonic
  module LoopedEvent
    class Sequence
      attr_reader :synth

      def initialize(synth, segments = [], humanize: false, probability: 1)
        @synth = synth
        @segments = segments
        @humanize = humanize
        @probability = probability
      end

      def start
        duration = @segments.count.to_s + Negasonic::NOTATION

        do_start(duration) do |time, note|
          @synth.trigger_attack_release(note, duration, time)
        end
      end

      def dispose
        @tone_sequence && @tone_sequence.dispose
      end

      def play(notes)
        @segments << LoopedEvent.to_tone_notes(Array(notes))
      end

      def scale(tonic_or_name, *opts)
        Negasonic::NotesGeneration.scale(tonic_or_name, *opts).to_a
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
    end
  end
end
