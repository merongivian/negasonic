module Negasonic
  module Time
    CYCLE_DURATION = 1200
    NOTATION = 'i'

    def self.schedule_next_cycle(&block)
      Tone::Transport.schedule_once(
        Tone::Transport.next_subdivision("#{CYCLE_DURATION}#{NOTATION}"),
        &block
      )
    end

    class Segments
      def initialize(segments)
        @segments = segments
      end

      def duration
        `Math.round(#{CYCLE_DURATION}/#{@segments.count}).toString()` + NOTATION
      end
    end
  end
end
