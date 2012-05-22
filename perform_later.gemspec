# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "perform_later/version"

Gem::Specification.new do |s|
  s.name        = "perform_later"
  s.version     = PerformLater::VERSION
  s.authors     = ["Avi Tzurel"]
  s.email       = ["avi@kensodev.com"]
  s.homepage    = "http://www.github.com/kensodev/perform_later"
  s.summary     = %q{Queue any method in any class or instance with no need for additional Worker class and no extra code}
  s.description = %q{Queue any method in any class or instance with no need for additional Worker class and no extra code}

  s.rubyforge_project = "perform_later"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency 'rails', '~> 3.0'
  s.add_dependency 'resque'
  s.add_dependency 'resque-loner'
  s.add_dependency 'redis'


  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'spork-rails'
  s.add_development_dependency 'fakeredis'
  s.add_development_dependency 'simplecov'
end
