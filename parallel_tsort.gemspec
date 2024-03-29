# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parallel_tsort/version'

Gem::Specification.new do |spec|
  spec.name          = "parallel_tsort"
  spec.version       = ParallelTsort::VERSION
  spec.authors       = ["Trae Robrock"]
  spec.email         = ["trobrock@gmail.com"]
  spec.description   = %q{Simple tool to resolve dependencies that can be run in parallel.}
  spec.summary       = %q{Simple tool to resolve dependencies that can be run in parallel.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
