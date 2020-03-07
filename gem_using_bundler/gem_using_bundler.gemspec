lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_using_bundler/version'

Gem::Specification.new do |spec|
  spec.name          = 'gem_using_bundler'
  spec.version       = GemUsingBundler::VERSION
  spec.authors       = [ 'Mark John Buenconsejo' ]
  spec.email         = [ 'hi@markjeee.com' ]

  spec.summary       = 'This is a gem using the bundler gem generator'
  spec.description   = 'A long description that goes with this gem'
  spec.homepage      = 'https://gemfury.com'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = [ 'lib' ]

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
