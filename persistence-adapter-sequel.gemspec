require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'persistence-adapter-sequel'
  spec.rubyforge_project         =  'persistence-adapter-sequel'
  spec.version                   =  '0.0.3'

  spec.summary                   =  "Adapter to use the Sequel Gem as a storage port for Persistence."
  spec.description               =  "Implements necessary methods to run Persistence on top of a SQL database."
  
  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/persistence-adapter-flat_file'
  
  spec.required_ruby_version     = ">= 1.9.1"
  
  spec.add_dependency            	'persistence'
  spec.add_dependency 						'sequel'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'gem-release'
  
  spec.date                      = Date.today.to_s
  
  spec.files                     = Dir[ '{lib,spec}/**/*',
                                        'README*', 
                                        'LICENSE*',
                                        'CHANGELOG*' ]

end
