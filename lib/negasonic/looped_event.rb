require 'js'
require 'negasonic/looped_event/part'
require 'negasonic/looped_event/pattern'
require 'negasonic/looped_event/sequence'

module Negasonic
  module LoopedEvent
    class << self
      def start(looped_element)
        looped_element.start('+15i')
        looped_element.loop = true
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
