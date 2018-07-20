# Negasonic

Ruby DSL for music live coding in the browser, you can play with it in the [online editor](https://negasonic.herokuapp.com/)

**DISCLAIMER:** This is pretty alpha, so use with care if you plan to use it for real performances... Otherwise have fun!

## Usage

### Playing Notes

You can use plain normal or midi notes

``` ruby
# playing a single note
play 42

# multiple notes
play 'E3', 42

# produces the same result as the above
play 'E3'
play 42

# Scales and chords (same as Sonic-pi)
play (scale :c, :major)
play (chord :d, :minor)
```

### Cycle

Under the hood we use a 'fixed' time for calculating notes durations, adding more notes or `play` statements will make durations
shorter. This happens because each `play` happens inside a `cycle`. A `cycle`'s duration is around 3 seconds

```ruby
# doing this
play 'E3'
play 42

# is the same as this
cycle do
  play 'E3'
  play 42
end
```

If you want to play notes at the same time then use multiple cycles

```ruby
cycle do
  play 'E3'
end

cycle do
  play 42
end
```

### Custom Instruments

With `with_instrument` you can add a synthesizer and connect it with effects. Every instrument needs
to have a name (for performance reasons)

```ruby

# The order of the effects will affect the final sound
with_instrument(:drums, synth: :membrane, fx: [:bit_crusher, :distortion]) do
  # each instrument has its own cycle by default
  play 30
  play 64
end

# multiple cycles can be used here as well
with_instrument(:lead, synth: :am, fx: :freeverb, volume: 3) do
  cycle do
    play (scale :c, :major)
  end

  cycle do
    play (scale :c, :pelog)
  end
end
```

### Custom Effects

It is possible to modify the default values for effects, you can do this trough the `fx` block. Options
for each effect are detailed in the [Effects section](https://github.com/merongivian/negasonic/tree/new-dsl#effects).

```ruby
drum_effects = fx do
  bit_crusher bits: 3
  distortion value: 1.3
end

with_instrument(:drums, synth: :membrane, fx: drum_effects) do
  4.times do
    play 30
    play 64
  end
end
```

### Cycle options

- `:expand` for a longer duration. Integer value
- `:probability` play or miss a note randomly. Float value between 0 and 1
- `:humanize` boolean value

### Synths

- `:membrane` Use it as drums
- `:simple`
- `:am`
- `:fm`
- `:duo`
- `:mono`
- `:metal`
- `:pluck`
- `:poly`

### Effects

| Effects         | Options                                            |
| --------------- | -------------------------------------------------- |
| vibrato         | `:frequency`, `:depth`                             |
| distortion      | `:value`                                           |
| chorus          | `:frequency`, `:delay_time`, `:depth`              |
| tremolo         | `:frequency`, `:depth`                             |
| feedback_delay  | `:delay_time`, `:feedback`                         |
| freeverb        | `:room_size`, `:dampening`                         |
| jc_reverb       | `:room_size`                                       |
| phaser          | `:frequency`, `:octaves`, `:base_frequency`        |
| ping_pong_delay | `:delay_time`, `:feedback`                         |
| auto_wah        | `:base_frequency`, `:octave`, `:sensitivity`, `:q` |
| bit_crusher     | `:bits`                                            |
| chebyshev       | `:order`                                           |
| pitch_shift     | `:pitch`                                           |

## Examples

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/merongivian/negasonic.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
