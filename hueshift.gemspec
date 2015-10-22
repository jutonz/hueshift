# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hueshift/version"

Gem::Specification.new do |spec|
  spec.name          = "hueshift"
  spec.version       = Hueshift::VERSION
  spec.authors       = ["Justin Toniazzo"]
  spec.email         = ["jutonz42@gmail.com"]

  spec.summary       = "Adjust your Hue lights using redshift/flux"
  spec.homepage      = "http://www.github.com/jutonz/hueshift"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = %w(hueshift)
  spec.require_paths = %w(lib)

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"

  spec.add_dependency "hue", "~> 0.1"
  spec.add_dependency "slop", "~> 4.2"
  spec.add_dependency "dotenv", "~> 2.0.0"
end
