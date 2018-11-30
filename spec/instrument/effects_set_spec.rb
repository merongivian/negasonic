require 'tone'
require 'negasonic/instrument/effects_set'

describe Negasonic::Instrument::EffectsSet do
  let(:effects_set) { described_class.new }

  describe '#create_from_array' do
    it 'creates a collection of tone effects just with effects names' do
      effects_set =
        Negasonic::Instrument::EffectsSet.create_from_array(%i(vibrato distortion chorus))

      expect(effects_set.nodes).to eq [
        Tone::Effect::Vibrato.new,
        Tone::Effect::Distortion.new,
        Tone::Effect::Chorus.new
      ]
    end
  end
end
