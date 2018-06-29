module Negasonic
  module LoopedEvent
    class Sequence
      def initialize(synth, segments = [])
        @synth = synth
        @segments = segments
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

      def play(*notes)
        @segments << LoopedEvent.to_tone_notes(notes)
      end

      private

      def do_start(duration, &block)
        @tone_sequence =
          Tone::Event::Sequence.new(@segments, duration, &block)

        LoopedEvent.start(@tone_sequence)
      end
    end
  end
end
