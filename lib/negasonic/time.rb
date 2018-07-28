module Negasonic
  module Time
    CYCLE_DURATION = 1200
    NOTATION = 'i'
    CYCLE_DURATION_IN_NOTATION = "#{CYCLE_DURATION}#{NOTATION}"
    @just_started = true
    @current_cycle_number = 0

    class << self
      attr_accessor :just_started, :current_cycle_number

      def schedule_next_cycle(&block)
        if @just_started
          block.call
        else
          Tone::Transport.schedule_once(
            (@current_cycle_number * CYCLE_DURATION).to_s + NOTATION,
            &block
          )
        end
      end

      def set_next_cycle_number_acummulator
        Tone::Transport.schedule_repeat(CYCLE_DURATION_IN_NOTATION) do
          Negasonic::Time.current_cycle_number += 1
        end
      end

      def stop
        if Tone::Transport.started?
          Tone::Transport.cancel
          Tone::Transport.stop

          @just_started = true
        end
      end
    end

    class Segments
      def initialize(segments, number_of_cycles)
        @segments = segments
        @number_of_cycles = number_of_cycles
      end

      def duration
        duration_number.JS.toString + NOTATION
      end

      def duration_number
        `Math.round(#{CYCLE_DURATION * @number_of_cycles}/#{@segments.count})`
      end
    end
  end
end
