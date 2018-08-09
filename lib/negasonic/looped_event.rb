require 'js'
require 'negasonic/looped_event/part'
require 'negasonic/looped_event/pattern'
require 'negasonic/looped_event/sequence'

module Negasonic
  module LoopedEvent
    class << self
      def start(looped_element, duration)
        looped_element.loop = true
        looped_element.loop_end = duration
        looped_element.start('+15i')
      end

      def to_tone_notes(notes)
        notes.map do |note|
          if JS.typeof(note) == 'string'
            note
          else
            # is a midi note
            (2**((note-69)/12) * 440).to_f
          end
        end
      end
    end
  end
end
