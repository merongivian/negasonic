module Negasonic
  module NotesGeneration
    module DSL
      def scale(tonic_or_name, *opts)
        NotesGeneration.scale(tonic_or_name, *opts).to_a
      end

      def chord(tonic_or_name, *opts)
        NotesGeneration.chord(tonic_or_name, *opts).to_a
      end

      def chord_degree(degree, tonic, scale=:major, number_of_notes=4, *opts)
        NotesGeneration.chord_degree(degree, tonic, scale=:major, number_of_notes=4, *opts)
      end
    end
  end
end
