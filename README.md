# Negasonic

Ruby DSL for music live coding in the browser, you can play with it in the [online editor](http://negasonic.onrender.com/)

**DISCLAIMER:** This is pretty alpha, so use with care if you plan to use it for real performances... Otherwise have fun!

Chat is available in gitter: [nega-sonic/Lobby](https://gitter.im/nega-sonic/Lobby) if you have any questions/suggestions

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
- `:every` plays every 'nth'. For example this: `cycle(every: 3)` will play every third cycle. Integer value
- `:sustain` reduce/augment the duration of notes. Float value between 0 and 1
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

- [random drums](https://negasonic.onrender.com/?code:with_instrument(%3Adrums%2C%20synth%3A%20%3Amembrane%2C%20fx%3A%20%5B%3Adistortion%2C%20%3Afreeverb%5D)%20do%0A%20%20cycle%20do%0A%20%20%20%202.times%20do%0A%20%20%20%20%20%20play%2030%0A%20%20%20%20%20%20play%2030%0A%20%20%20%20%20%20play%200%0A%20%20%20%20%20%20play%2040%0A%20%20%20%20end%0A%20%20end%0A%20%20%0A%20%20cycle%20do%0A%20%20%20%202.times%20do%0A%20%20%20%20%20%20play%200%0A%20%20%20%20%20%20play%2070%0A%20%20%20%20end%0A%20%20end%0A%20%20%0A%20%20cycle%20do%0A%20%20%20%202.times%20do%0A%20%20%20%20%20%20play%2060%0A%20%20%20%20%20%20play%200%0A%20%20%20%20end%0A%20%20end%0A%20%20%0A%20%20cycle(every%3A%202)%20do%0A%20%20%20%208.times%20do%0A%20%20%20%20%20%20play%2075%0A%20%20%20%20%20%20play%200%0A%20%20%20%20end%0A%20%20end%0A%20%20%0A%20%20cycle(every%3A%208%2C%20probability%3A%200.4)%20do%0A%20%20%20%2016.times%20do%0A%20%20%20%20%20%20play%2075%0A%20%20%20%20%20%20play%200%0A%20%20%20%20%20%20play%2065%0A%20%20%20%20%20%20play%200%0A%20%20%20%20%20%20play%2070%0A%20%20%20%20end%0A%20%20end%0A%20%20%0A%20%20cycle(every%3A%202%2C%20probability%3A%200.6%2C%20expand%3A%202)%20do%0A%20%20%20%208.times%20do%0A%20%20%20%20%20%20play%2030%0A%20%20%20%20%20%20play%200%0A%20%20%20%20%20%20play%2040%0A%20%20%20%20%20%20play%200%0A%20%20%20%20%20%20play%2050%0A%20%20%20%20end%0A%20%20end%0Aend%0A%0Awith_instrument(%3Abass%2C%20synth%3A%20%3Aduo%2C%20fx%3A%20%5B%3Avibrato%2C%20%3Afeedback_delay%2C%20%3Ajc_reverb%5D)%20do%0A%20%20cycle(expand%3A%204)%20do%0A%20%20%20%20play%20(scale%20%3Agb%2C%20%3Apelog).last(4)%0A%20%20end%0A%20%20%0A%20%20cycle(expand%3A%2016)%20do%0A%20%20%20%20play%20(scale%20%3Agb%2C%20%3Apelog).first(4)%0A%20%20end%0Aend)
- [arabian space](https://negasonic.onrender.com/?code:scale_type%20%3D%20%3Adorian%0A%0Awith_instrument(%3Abass%2C%20synth%3A%20%3Afm%2C%20fx%3A%20%3Afreeverb%2C%20volume%3A%20-8)%20do%0A%20%20play%20scale(%3Ac%2C%20scale_type).reverse%0Aend%0A%0Awith_instrument(%3Amiddle%2C%20synth%3A%20%3Aduo%2C%20volume%3A%201)%20do%0A%20%202.times%20do%0A%20%20%20%20play%20scale(%3Ac3%2C%20scale_type)%0A%20%20end%0Aend%0A%0Awith_instrument(%3Alead%2C%20synth%3A%20%3Aam%2C%20fx%3A%20%5B%3Avibrato%2C%20%3Afeedback_delay%2C%20%3Afreeverb%5D)%20do%0A%20%204.times%20do%0A%20%20%20%20play%20scale(%3Ac4%2C%20scale_type)%0A%20%20end%0A%20%20%0A%20%202.times%20do%0A%20%20%20%20play%20scale(%3Ac5%2C%20scale_type)%0A%20%20end%0A%20%20%0A%20%20cycle(probability%3A%200.3%2C%20humanize%3A%20true)%20do%0A%20%20%20%207.times%20do%0A%20%20%20%20%20%20play%20scale(%3Ac6%2C%20scale_type).shuffle%0A%20%20%20%20end%0A%20%20end%0Aend%0A%0Awith_instrument(%3Adrums%2C%20synth%3A%20%3Amembrane%2C%20fx%3A%20%5B%3Abit_crusher%2C%20%3Adistortion%5D)%20do%0A%20%20play%2030%0A%20%20play%2062%0A%20%20play%2030%0A%20%20play%2062%0A%20%20%0A%20%20cycle%20do%0A%20%20%20%20play%2035%0A%20%20%20%20play%2065%0A%20%20%20%20%0A%20%20%20%202.times%20do%0A%20%20%20%20%20%20play%2035%2C%2065%0A%20%20%20%20end%0A%20%20end%0Aend)
- [supernintendo gangsta](https://negasonic.onrender.com/?code:with_instrument(%3Adrums%2C%20synth%3A%20%3Amembrane%2C%20fx%3A%20%3Adistortion)%20do%0A%20%202.times%20do%0A%20%20%20%20play%2030%0A%20%20%20%20play%2062%0A%20%20end%0A%20%20%0A%20%20cycle(humanize%3A%20true)%20do%0A%20%20%20%204.times%20do%0A%20%20%20%20%20%20play%20115%0A%20%20%20%20%20%20play%2020%2C%2010%0A%20%20%20%20end%0A%20%20end%0A%20%20%0A%20%20cycle%20do%0A%20%20%20%202.times%20do%0A%20%20%20%20%20%20play%2094%0A%20%20%20%20%20%20play%2084%2C%2074%0A%20%20%20%20end%0A%20%20end%0Aend%0A%0Anote%20%3D%20%3Ac%0Ascale_type%20%3D%20%3Apelog%0A%0Awith_instrument(%3Abass%2C%20synth%3A%20%3Aduo%2C%20fx%3A%20%3Afreeverb)%20do%0A%20%20play%20scale(%22%23%7Bnote%7D2%22%2C%20scale_type).reverse%0Aend%0A%0Awith_instrument(%3Amid%2C%20synth%3A%20%3Afm%2C%20fx%3A%20%3Adistortion%2C%20volume%3A%20-11)%20do%0A%20%202.times%20do%0A%20%20%20%20play%20scale(%22%23%7Bnote%7D4%22%2C%20scale_type)%0A%20%20end%0Aend%0A%0Awith_instrument(%3Alead%2C%20synth%3A%20%3Aam%2C%20fx%3A%20%5B%3Avibrato%2C%20%3Afeedback_delay%2C%20%3Afreeverb%5D%2C%20volume%3A%20-3)%20do%0A%20%202.times%20do%0A%20%20%20%20play%20scale(%22%23%7Bnote%7D6%22%2C%20scale_type).shuffle%0A%20%20end%0A%20%20%0A%20%202.times%20do%0A%20%20%20%20play%20scale(%22%23%7Bnote%7D5%22%2C%20scale_type).shuffle%0A%20%20end%0A%20%20%0A%20%202.times%20do%0A%20%20%20%20play%20scale(%22%23%7Bnote%7D7%22%2C%20scale_type).shuffle%0A%20%20end%0A%20%20%0A%20%20cycle(probability%3A%200.3%2C%20humanize%3A%20true)%20do%0A%20%20%20%20play%20scale(%22%23%7Bnote%7D8%22%2C%20scale_type).shuffle%0A%20%20end%0Aend)
- [dancing in china](https://negasonic.onrender.com/?code:with_instrument(%3Adrums%2C%20synth%3A%20%3Amembrane%2C%20fx%3A%20%5B%3Abit_crusher%2C%20%3Adistortion%2C%20%3Afreeverb%5D%2C%20volume%3A%2010)%20do%0A%20%20cycle()%20do%0A%20%20%20%206.times%20do%0A%20%20%20%20%20%20play%2030%0A%20%20%20%20%20%20play%2062%0A%20%20%20%20end%0A%20%20end%0A%20%20%0A%20%20cycle%20do%0A%20%20%20%203.times%20do%0A%20%20%20%20%20%20play%2030%0A%20%20%20%20%20%20play%2062%0A%20%20%20%20end%0A%20%20end%0A%20%20%0A%20%20cycle%20do%0A%20%20%20%204.times%20do%0A%20%20%20%20%20%20play%2072%0A%20%20%20%20%20%20play%2062%0A%20%20%20%20end%0A%20%20end%0Aend%0A%0Awith_instrument(%3Amid%2C%20synth%3A%20%3Afm%2C%20fx%3A%20%5B%3Adistortion%2C%20%3Avibrato%2C%20%3Afeedback_delay%2C%20%3Afreeverb%5D%2C%20volume%3A%20-4)%20do%0A%20%20scale_type%20%3D%20%3Aritusen%0A%20%20%0A%20%20play%20(scale(%3Af%2C%20scale_type)%20*%203)%0A%20%20%0A%20%20cycle(humanize%3A%20true%2C%20probability%3A%200.2)%20do%0A%20%20%20%20play%20scale(%3Af6%2C%20scale_type).shuffle%0A%20%20end%0Aend)

## Issues

- Using `every` is pretty unstable at the moment, even more if you use it in combination with `expand`
- Adding too much notes on a cycle causes the page to crash ( like doing `100.times do { play 30, 50, 60 }` )
- Page crashes also when you have a lot of cycles and you hit the 'play' button to fast (fixing this soon™)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/merongivian/negasonic.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
