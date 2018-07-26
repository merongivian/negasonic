require 'negasonic/notes_generation/dsl'
require 'negasonic/time'

module Negasonic
  module LoopedEvent
    class Sequence
      attr_reader :synth

      include Negasonic::NotesGeneration::DSL

      def initialize(synth, segments = [], humanize: false, probability: 1, expand: 1, every: 1, sustain: 0.15)
        raise 'using every while expanding the cycle is disabled for now' if expand > 1 && every > 1

        @synth = synth
        @segments = segments
        @humanize = humanize
        @probability = probability
        @number_of_cycles = expand
        @every = every
        @sustain = sustain
      end

      def start
        sustain =
          `Math.round(#{segment_calculator.duration_number}*#{@sustain}).toString()` + Negasonic::Time::NOTATION

        init_sequence(segment_calculator.duration) do |time, note|
          @synth.trigger_attack_release(note, sustain, time)
        end

        set_pause_by_every
        LoopedEvent.start(@tone_sequence)
      end

      def dispose
        @tone_sequence && @tone_sequence.dispose
      end

      def play(*notes)
        @segments << LoopedEvent.to_tone_notes(notes.flatten)
      end

      private

      def set_pause_by_every
        %x{
          Tone.Transport.scheduleRepeat(function(){
            if (Tone.Transport.nextCycleNumber % #@every == 0) {
              #{@tone_sequence.mute = false}
            } else {
              #{@tone_sequence.mute = true}
            }
          }, #{Negasonic::Time::CYCLE_DURATION_IN_NOTATION})
        }
      end

      def init_sequence(duration, &block)
        @tone_sequence = Tone::Event::Sequence.new(@segments, duration, &block).tap do |sequence|
          sequence.humanize = @humanize
          sequence.probability = @probability
        end
      end

      def segment_calculator
        Negasonic::Time::Segments.new(@segments, @number_of_cycles)
      end
    end
  end
end
