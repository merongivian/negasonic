require 'negasonic/looped_event/part'
require 'negasonic/looped_event/pattern'
require 'negasonic/looped_event/sequence'

module Negasonic
  module LoopedEvent
    @events = []

    class << self
      attr_accessor :events

      def dispose_all
        @events.each(&:dispose)
        @events = []
      end

      def start(looped_element)
        looped_element.start(0)
        looped_element.loop = true
        @events << looped_element
      end

      def midi_notes_to_frequencies(midi_notes)
        midi_notes.map do |midi_note|
          2**((midi_note-69)/12) * 440
        end
      end
    end
  end
end
