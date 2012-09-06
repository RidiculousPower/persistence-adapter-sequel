
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require "persistence/adapter/sequel/version"
 
Gem::Specification.new do |s|
  s.name        = "persistence-adapter-sequel"
  s.version     = Persistence::Adapter::Sequel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Conner M-Toups"]
  s.email       = ["cmtoups@me.com"]
  s.homepage    = "https://github.com/CMToups/persistence-adapter-sequel"
  s.summary     = "An adapter that uses the Sequel gem (a wrapper for relational databases) as a storage port for Persistence."
  s.description = "Implements necessary methods to run Persistence on top of the Sequel gem."

 #s.rubyforge_project = "persistence-adapter-sequel"
 
  s.add_dependency "persistence"
  s.add_dependency "sequel"
  s.add_dependency "pg"
  s.add_development_dependency "rspec"
  s.add_development_dependency "gem-release"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(README.md CHANGELOG.rdoc)
  s.require_path = 'lib'
end