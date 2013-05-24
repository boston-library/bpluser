$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bpluser/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bpluser"
  s.version     = Bpluser::VERSION
  s.authors     = ["Boston Public Library Web Services"]
  s.email       = ["sanderson@bpl.org"]
  s.homepage    = "http://www.bpl.org"
  s.summary     = "Shared user access gem of BPL"
  s.description = "Shared user access gem of BPL"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "omniauth"
  s.add_dependency "omniauth-ldap"
  s.add_dependency "omniauth-facebook"
  #s.add_dependency 'omniauth-polaris', :git => 'https://github.com/boston-library/omniauth-polaris.git'
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
