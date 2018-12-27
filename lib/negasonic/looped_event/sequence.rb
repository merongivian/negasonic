require 'negasonic/notes_generation/dsl'
require 'negasonic/time'

module Negasonic
  module LoopedEvent
    class Sequence
      attr_reader :synth

      include Negasonic::NotesGeneration::DSL

      @all = []

      class << self
        attr_accessor :all

        def find(name)
          @all.find do |sequence|
            sequence.name == name
          end
        end

        def add(name)
          new(name).tap do |sequence|
            @all << sequence
          end
        end

        def find_or_add(name)
          find(name) || add(name)
        end
      end

      attr_reader :name

      def initialize(name)
        @name = name
        @tone_sequence = nil
      end

      def set_values(synth, segments = [], humanize: false, probability: 1, expand: 1, every: 1, sustain: 0.15)
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

          new_tone_sequence = init_sequence(segment_calculator.duration) do |time, note|
            @synth.trigger_attack_release(note, sustain, time)
          end

          if @tone_sequence != new_tone_sequence
            dispose_tone_sequence
            @tone_sequence = new_tone_sequence
            set_pause_by_every
            LoopedEvent.start(@tone_sequence, duration)
          else
            @new_tone_sequence.dispose
          end
        end
      end

      def dispose_tone_sequence
        cancel_pause_by_every
        @tone_sequence && @tone_sequence.dispose
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
          Tone::Transport.schedule_once(
            (next_cycle_number * Negasonic::Time::CYCLE_DURATION).to_s + Negasonic::Time::NOTATION,
            &block
          )
        end
      end

      def set_pause_by_every
        @every_event_id = Tone::Transport.schedule_repeat(duration) do
          if (next_cycle_number / @number_of_cycles) % @every  == 0
            @tone_sequence.mute = false
          else
            @tone_sequence.mute = true
          end
        end
      end

      def cancel_pause_by_every
        @every_event_id && Tone::Transport.clear(@every_event_id)
      end

      def init_sequence(segment_duration, &block)
        Tone::Event::Sequence.new(@segments, segment_duration, &block).tap do |sequence|
          sequence.humanize = @humanize
          sequence.probability = @probability
        end
      end

      def next_cycle_number
        if @number_of_cycles > 1
          (Negasonic::Time.next_cycle_number..(Negasonic::Time.next_cycle_number + @number_of_cycles)).find do |cycle_number|
            cycle_number % @number_of_cycles == 0
          end
        else
          Negasonic::Time.next_cycle_number
        end
      end

      def duration
        (Negasonic::Time::CYCLE_DURATION * @number_of_cycles).to_s +
          Negasonic::Time::NOTATION
      end

      def segment_calculator
        Negasonic::Time::Segments.new(@segments, @number_of_cycles)
      end
    end
  end
end
