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
        schedule_next do
          sustain =
            `Math.round(#{segment_calculator.duration_number} * #@number_of_cycles * #@sustain).toString()` + Negasonic::Time::NOTATION

          init_sequence(segment_calculator.duration) do |time, note|
            @synth.trigger_attack_release(note, sustain, time)
          end

          set_pause_by_every
          LoopedEvent.start(@tone_sequence)
        end
      end

      def dispose
        schedule_next do
          cancel_pause_by_every
          @tone_sequence && @tone_sequence.dispose
        end
      end

      def play(*notes)
        @segments << LoopedEvent.to_tone_notes(notes.flatten)
      end

      private

      def schedule_next(&block)
        return if @segments.empty?

        if Negasonic::Time.just_started
          block.call
        else
          next_cycle_number = if @number_of_cycles > 1
                           (Negasonic::Time.current_cycle_number..(Negasonic::Time.current_cycle_number + @number_of_cycles)).find do |cycle_number|
                             cycle_number % @number_of_cycles == 0
                           end
                         else
                           Negasonic::Time.current_cycle_number
                         end

          Tone::Transport.schedule_once(
            (next_cycle_number * Negasonic::Time::CYCLE_DURATION).to_s + Negasonic::Time::NOTATION,
            &block
          )
        end
      end

      def set_pause_by_every
        @every_event_id = Tone::Transport.schedule_repeat(Negasonic::Time::CYCLE_DURATION_IN_NOTATION) do
          if Negasonic::Time.current_cycle_number % @every == 0
            @tone_sequence.mute = false
          else
            @tone_sequence.mute = true
          end
        end
      end

      def cancel_pause_by_every
        @every_event_id && Tone::Transport.clear(@every_event_id)
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
