# Negasonic

Ruby DSL for music live coding in the browser, you can play with it in the [online editor](https://negasonic.herokuapp.com/)

DISCLAIMER: The current DSL might change in the future

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'negasonic'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install negasonic

## Usage

Most of the audio capabilities are handled by [Tone.rb](https://github.com/merongivian/tone.rb), which is a wrapper
over [Tone.js](https://github.com/Tonejs/Tone.js), you can check how effects/synths works in the [official docs](https://tonejs.github.io/docs/)

`instrument` is in charged of hooking up a synth with a chain of effects

```ruby
# instruments need to be named in order to use it later
instrument(:lead, synth: :am, volume: 1) do
  # The order of the effects will affect the final sound
  vibrato frequency: 5, depth: 0.1
  jc_reverb room_size: 0.5
end
```

In `pattern` we define which notes will be played in the instrument. The interval value uses
Tone.js's time notation, [read about time notation](https://github.com/Tonejs/Tone.js/wiki/Time)

```ruby
pattern(instrument: :lead, interval: '4n', type: :random, notes: [36, "D2", 40, "A2"])
```

Notes can be plain normal or MIDI notes

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/merongivian/negasonic.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
