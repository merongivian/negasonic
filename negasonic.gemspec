
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "negasonic/version"

Gem::Specification.new do |spec|
  spec.name          = "negasonic"
  spec.version       = Negasonic::VERSION
  spec.authors       = ["Jose Anasco"]
  spec.email         = ["joseanasco1@gmail.com"]

  spec.summary       = %q{Music live coding in the browser}
  spec.description   = %q{Ruby DSL for music live coding in web-audio}
  spec.homepage      = "http://github.com/merongivian/negasonic"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'tone.rb'
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
