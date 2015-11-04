# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puffery/version'

Gem::Specification.new do |spec|
  spec.name          = "puffery"
  spec.version       = Puffery::VERSION
  spec.authors       = ["Gustav"]
  spec.email         = ["gustav@invoke.se"]
  spec.summary       = %q{Simple DSL to generate ad groups and keywords}
  spec.description   = %q{Simple DSL to generate ad groups and keywords}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "excon"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "minitest-reporters"

end
