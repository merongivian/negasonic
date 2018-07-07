module Negasonic
  module Time
    CYCLE_DURATION = 8609
    NOTATION = 'i'
    BMP = 100

    def self.schedule_next_cycle(&block)
      Tone::Transport.schedule_once(
        Tone::Transport.next_subdivision("#{CYCLE_DURATION}#{NOTATION}"),
        &block
      )
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
