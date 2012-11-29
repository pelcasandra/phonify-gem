# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'phonify/version'
 
Gem::Specification.new do |s|
  s.name        = "phonify"
  s.version     = Phonify::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Martin Caetano", "Chew Choon Keat"]
  s.email       = ["info@phonify.io"]
  s.homepage    = "https://github.com/pelcasandra/phonify-gem"
  s.summary     = "Phonify.io ruby client."
  s.description = "Phonify gem adds the power of Phonify service directly in your app. More info on http://www.phonify.io/help"
 
  s.required_rubygems_version = ">= 1.3.6"

  s.add_runtime_dependency "activerecord" 
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE.txt README.md CHANGELOG.md Gemfile Gemfile.lock Guardfile)
  # s.executables  = ['bundle']
  s.require_path = 'lib'
end
