# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'bpluser/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'bpluser'
  s.version     = Bpluser::VERSION
  s.authors     = ['Boston Public Library Repository Services']
  s.email       = ['digital@bpl.org', 'bbarber@bpl.org', 'eenglish@bpl.org']
  s.homepage    = 'http://www.bpl.org'
  s.summary     = 'Shared user access gem for public front ends'
  s.description = 'Shared user access gem for public front ends'
  s.license     = 'MIT'

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.2', '< 3.5'

  # s.add_dependency 'blacklight', '~> 8.11.0'
  s.add_dependency 'blacklight', '~> 8.12.0'
  s.add_dependency 'devise', '~> 4.9'
  s.add_dependency 'devise-guests', '~> 0.8'
  s.add_dependency 'omniauth', '~> 2.1'
  s.add_dependency 'omniauth-polaris', '~> 1.2'
  s.add_dependency 'omniauth-rails_csrf_protection', '~> 1.0'
  s.add_dependency 'rails', '~> 7.2'
  s.add_dependency 'recaptcha', '~> 5.20'

  s.add_development_dependency 'pg', '>= 0.18', '< 2.0'
  s.add_development_dependency 'rsolr', '~> 2.6'
  s.add_development_dependency 'rspec-rails', '>= 6.1', '< 8'
  s.add_development_dependency 'solr_wrapper', '~> 4.2'
end
