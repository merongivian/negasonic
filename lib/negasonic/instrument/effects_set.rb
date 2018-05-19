module Negasonic
  class Instrument
    class EffectsSet
      attr_reader :nodes

      def initialize
        @nodes = []
      end

      def reload
        @nodes = []
      end

      def vibrato(**opts)
        @nodes << Tone::Effect::Vibrato.new(**opts)
      end

      def distortion(**opts)
        @nodes << Tone::Effect::Distortion.new(**opts)
      end

      def chorus(**opts)
        @nodes << Tone::Effect::Chorus.new(**opts)
      end

      def tremolo(**opts)
        @nodes << Tone::Effect::Tremolo.new(**opts)
      end

      def feedback_delay(**opts)
        @nodes << Tone::Effect::FeedbackDelay.new(**opts)
      end

      def freeverb(**opts)
        @nodes << Tone::Effect::Freeverb.new(**opts)
      end

      def jc_reverb(**opts)
        @nodes << Tone::Effect::JCReverb.new(**opts)
      end

      def phaser(**opts)
        @nodes << Tone::Effect::Phaser.new(**opts)
      end

      def ping_pong_delay(**opts)
        @nodes << Tone::Effect::PingPongDelay.new(**opts)
      end
    end
  end
end
