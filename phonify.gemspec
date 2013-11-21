$:.push File.expand_path('../lib', __FILE__)
 
require 'phonify/version'
 
Gem::Specification.new do |s|
  s.name        = 'phonify'
  s.version     = Phonify::VERSION
  s.authors     = ['Martin Caetano', 'Chew Choon Keat', 'Mathías Montossi']
  s.email       = ['info@phonify.io']
  s.homepage    = 'https://github.com/pelcasandra/phonify-gem'
  s.summary     = 'Phonify.io ruby client.'
  s.description = 'Phonify gem adds the power of Phonify service directly in your app. More info on http://www.phonify.io/help.'
  s.license     = 'MIT' 

  s.add_development_dependency 'rspec'
 
  s.files = Dir['lib/**/*', 'MIT-LICENSE.txt', 'README.md']
end
