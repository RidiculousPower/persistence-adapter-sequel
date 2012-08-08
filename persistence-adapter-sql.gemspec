# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "persistence/adapter/sql/version"

Gem::Specification.new do |s|
  s.name        = "persistence-adapter-sql"
  s.version     = Persistence::Adapter::Sql::VERSION
  s.authors     = ["CMToups"]
  s.email       = ["CMToups@me.com"]
  s.homepage    = ""
  s.summary     = "Sql Adapter for Persistence"
  s.description = "Currenly in dev"

  s.rubyforge_project = "persistence-adapter-sql"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_dependency "persistence"
  s.add_dependency "sequel"
  s.add_development_dependency "pkondzior-sequel_nested_set"
  s.add_dependency "pg"
  s.add_development_dependency "development"
  s.add_development_dependency "gem-release"
  # s.add_runtime_dependency "rest-client"
end
