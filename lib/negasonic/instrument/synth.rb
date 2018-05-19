module Negasonic
  class Instrument
    class Synth
      class << self
        def simple(**opts)
          Tone::Synth::Simple.new(**opts)
        end

        def membrane(**opts)
          Tone::Synth::Membrane.new(**opts)
        end

        def am(**opts)
          Tone::Synth::AM.new(**opts)
        end

        def fm(**opts)
          Tone::Synth::FM.new(**opts)
        end

        def duo(**opts)
          Tone::Synth::Duo.new(**opts)
        end

        def mono(**opts)
          Tone::Synth::Mono.new(**opts)
        end

        def pluck(**opts)
          Tone::Synth::Pluck.new(**opts)
        end

        def poly(**opts)
          Tone::Synth::Poly.new(**opts)
        end
      end
    end
  end
end
