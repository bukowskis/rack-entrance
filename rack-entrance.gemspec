$: << File.expand_path('../lib', __FILE__)
require 'rack/entrance/version'

Gem::Specification.new do |spec|

  spec.authors      = %w{ bukowskis }
  spec.summary      = "A tiny middleware that determines whether this request was from the internal network or not."
  spec.description  = "A tiny middleware that determines whether this request was from the internal network or not."
  spec.homepage     = 'https://github.com/bukowskis/rack-entrance'
  spec.license      = 'MIT'

  spec.name         = 'rack-entrance'
  spec.version      = Rack::Entrance::VERSION::STRING

  spec.files        = Dir['{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  spec.require_path = 'lib'

  spec.rdoc_options.concat ['--encoding',  'UTF-8']

  spec.add_dependency('rack')

  spec.add_development_dependency('rack-test')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('guard-rspec')
  spec.add_development_dependency('rb-fsevent')

end
