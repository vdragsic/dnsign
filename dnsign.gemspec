# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dnsign/version'

Gem::Specification.new do |spec|
  spec.name          = "dnsign"
  spec.version       = Dnsign::VERSION
  spec.authors       = ["Veljko Dragsic"]
  spec.email         = ["veljko@floatingpoint.io"]
  spec.summary       = %q{Dynamic DNS updater}
  spec.description   = "Simple command line tool that resolves your public IP address and accordingly updates DNS record on one of the currently supported (Linode, DigitalOcean) DNS services."
  spec.homepage      = "http://github.com/vdragsic/dnsign"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "timers", "~> 4.0"
  spec.add_dependency "droplet_kit", "~> 1.2"
  spec.add_dependency "linode", "~> 0.8"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "webmock", "~> 1.21"
  spec.add_development_dependency "vcr", "~> 2.9"
end
