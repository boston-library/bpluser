$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bpluser/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bpluser"
  s.version     = Bpluser::VERSION
  s.authors     = ["Boston Public Library Web Services"]
  s.email       = ['sanderson@bpl.org', 'bbarber@bpl.org' ]
  s.homepage    = "http://www.bpl.org"
  s.summary     = "Shared user access gem of BPL"
  s.description = "Shared user access gem of BPL"
  s.license     = "MIT"

  s.files =       Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]+
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.required_ruby_version = '~> 2.4'

  s.add_dependency "rails", '>= 5', '< 6'
  s.add_dependency "omniauth", '~> 1.8.1', '< 1.9.0'
  s.add_dependency "omniauth-ldap", '2.0.0'
  s.add_dependency "omniauth-facebook", '5.0.0'
  s.add_dependency "hydra-role-management", '1.0.0'
  s.add_dependency 'active-fedora', '>= 8.0.1', '< 9'
  s.add_dependency 'hydra-ldap', '0.1.0'
  s.add_dependency 'devise', '4.5.0'
  s.add_dependency 'devise-guests', '0.6.1'
  s.add_dependency 'omniauth-polaris', '1.0.5'

  s.add_development_dependency 'bundler', '~> 1.3', '>= 1.3.0'
  s.add_development_dependency 'rake', '~> 12.3', '>= 12.3.0'
  s.add_development_dependency 'rspec-rails', '~> 3.8'
  s.add_development_dependency 'awesome_print', '~> 1.8'
  s.add_development_dependency "sqlite3", '~> 1.3', '>= 1.3.0'
end
