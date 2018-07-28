module Negasonic
  module Time
    CYCLE_DURATION = 1200
    NOTATION = 'i'
    CYCLE_DURATION_IN_NOTATION = "#{CYCLE_DURATION}#{NOTATION}"
    # HACK: theres some delay each time the next cycle is played, causing the first note
    # to be missed by tone js
    ERROR_MARGIN = 15
    @just_started = true

    class << self
      attr_accessor :just_started, :next_cycle_number

      def schedule_next_cycle(&block)
        if @just_started
          block.call
        else
          Tone::Transport.schedule_once(
            `((Tone.Transport.currentCycleNumber) * #{CYCLE_DURATION}) - #{ERROR_MARGIN} + #{NOTATION}`,
            &block
          )
        end
      end

      def set_next_cycle_number_acummulator
        %x{
          Tone.Transport.currentCycleNumber = 0
          Tone.Transport.scheduleRepeat(function(){
            Tone.Transport.currentCycleNumber += 1;
          }, #{CYCLE_DURATION_IN_NOTATION})
        }
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
