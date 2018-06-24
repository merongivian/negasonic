if RUBY_ENGINE == 'opal'
  require 'tone'
  require 'negasonic/instrument'
  require 'negasonic/looped_event'
  require 'negasonic/dsl'

  extend Negasonic::DSL

  module Negasonic
    NOTATION = "n"
  end
else
  require 'opal'

  Opal.append_path File.expand_path('../', __FILE__).untaint
end
