# Negasonic

Ruby DSL for music live coding in the browser, you can play with it in the [online editor](https://negasonic.herokuapp.com/)

**DISCLAIMER:** This is pretty alpha, so use with care if you plan to use it for real performances... otherwise have fun!

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

# Scales and chords (same as Soni-pi)
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

if you want to play notes at the same time then use multiple cycles

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

### Cycle options

- `:duration` expands the cycle. accepts integer values
- `:probability` float value
- `:humanize` boolean value

## Examples

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'negasonic'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install negasonic

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/merongivian/negasonic.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
