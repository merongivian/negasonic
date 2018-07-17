module Negasonic
  module Time
    CYCLE_DURATION = 8616
    NOTATION = 'i'
    @just_started = true

    class << self
      attr_accessor :just_started

      def schedule_next_cycle(&block)
        if @just_started
          block.call
        else
          Tone::Transport.schedule_once(
            Tone::Transport.next_subdivision("#{CYCLE_DURATION}#{NOTATION}"),
            &block
          )
        end
      end

      def pause
        if Tone::Transport.started?
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
        `Math.round(#{CYCLE_DURATION * @number_of_cycles}/#{@segments.count}).toString()` + NOTATION
      end
    end
  end
end
