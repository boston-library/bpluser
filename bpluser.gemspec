$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bpluser/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bpluser"
  s.version     = Bpluser::VERSION
  s.authors     = ["Boston Public Library Repository Services"]
  s.email       = ['sanderson@bpl.org', 'bbarber@bpl.org', 'eenglish@bpl.org']
  s.homepage    = "http://www.bpl.org"
  s.summary     = "Shared user access gem of BPL"
  s.description = "Shared user access gem of BPL"
  s.license     = "MIT"

  s.files =       Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]+
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.required_ruby_version = '~> 2.4'

  s.add_dependency "rails", '~> 6.0.3'
  s.add_dependency 'blacklight', '~> 7.8'
  s.add_dependency "omniauth", '~> 1.8.1'
  s.add_dependency "omniauth-ldap", '2.0.0'
  s.add_dependency "omniauth-facebook", '5.0.0'
  s.add_dependency 'hydra-ldap', '0.1.0'
  s.add_dependency 'devise', '~> 4.7.0'
  s.add_dependency 'devise-guests', '0.7.0'
  s.add_dependency 'omniauth-polaris', '1.0.5'

  s.add_development_dependency 'rspec-rails', '~> 3.9', '< 4.0'
  s.add_development_dependency 'awesome_print', '~> 1.8'
end
