# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crimp/version'

Gem::Specification.new do |spec|
  spec.name          = "crimp"
  spec.version       = Crimp::VERSION
  spec.authors       = ["Robert Kenny", "Mark McDonnell"]
  spec.email         = ["kenoir@gmail.com","mark.mcdx@gmail.com"]
  spec.summary       = %q{Creating an md5 hash of a number, string, array, or hash in Ruby}
  spec.description   = <<-EOS.gsub /^\s+/, ""
                         Shamelessly lifted from http://stackoverflow.com/questions/6461812/creating-an-md5-hash-of-a-number-string-array-or-hash-in-ruby

                         All credit should go to http://stackoverflow.com/users/394282/luke
                       EOS
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake-rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
end
