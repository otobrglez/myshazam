# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'myshazam/version'

Gem::Specification.new do |spec|
  spec.name          = "myshazam"
  spec.version       = Myshazam::VERSION
  spec.authors       = ["Oto Brglez"]
  spec.email         = ["otobrglez@gmail.com"]
  spec.summary       = %q{Tools for working with Shazam dumps}
  spec.description   = %q{Set of scripts to work with your Shazam data}
  spec.homepage      = "http://github.com/otobrglez/myshazam"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.6"


  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
