#--
# This file is part of Sonic Pi: http://sonic-pi.net
# Full project source: https://github.com/samaaron/sonic-pi
# License: https://github.com/samaaron/sonic-pi/blob/master/LICENSE.md
#
# Copyright 2013, 2014, 2015, 2016 by Sam Aaron (http://sam.aaron.name).
# All rights reserved.
#
# Permission is granted for use, copying, modification, and
# distribution of modified versions of this work as long as this
# notice is included.
#++
require 'negasonic/notes_generation/wrapping_array'
require 'negasonic/notes_generation/note'
require 'negasonic/notes_generation/scale'

module Negasonic
  module NotesGeneration
    class << self
      def scale(tonic_or_name, *opts)
        tonic = 0
        name = :minor
        if opts.size == 0
          name = tonic_or_name
        elsif (opts.size == 1) && opts[0].is_a?(Hash)
          name = tonic_or_name
        else
          tonic = tonic_or_name
          name = opts.shift
        end

        opts = resolve_synth_opts_hash_or_array(opts)
        opts = {:num_octaves => 1}.merge(opts)
        Scale.new(tonic, name,  opts[:num_octaves])
      end

      def resolve_synth_opts_hash_or_array(opts)
        case opts
        when Hash
          return opts
        when Array
          merge_synth_arg_maps_array(opts)
        when NilClass
          return {}
        else
          raise "Invalid options. Options should either be an even list of key value pairs, a single Hash or nil. Got #{opts.inspect}"
        end
      end

      def merge_synth_arg_maps_array(opts_a)
        return opts_a if opts_a.is_a? Hash

        # merge all initial hash elements
        # assumes rest of args are kv pairs and turns
        # them into hashes too and merges the
        opts_a = opts_a.to_a
        res = {}
        idx = 0
        size = opts_a.size

        while (idx < size) && (m = opts_a[idx]).is_a?(Hash)
          res = res.merge(m)
          idx += 1
        end

        return res if idx == size
        left = (opts_a[idx..-1])
        raise "There must be an even number of trailing synth args" unless left.size.even?
        h = Hash[*left]
        res.merge(h)
      end
    end
  end
end
