# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }
# Declare your gem's dependencies in bpluser.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.8', require: 'dotenv/rails-now'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.1'
  gem 'rubocop', '~> 1.61.0', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-performance', '~> 1.19.1', require: false
  gem 'rubocop-rails', '~> 2.22.1', require: false
  gem 'rubocop-rspec', '~> 2.31.0', require: false
end

group :test do
  gem 'capybara', '~> 3.38', '< 4'
  gem 'climate_control', '~> 1.1'
  gem 'coveralls_reborn', '~> 0.28.0', require: false
  gem 'database_cleaner-active_record', '~> 2.1'
  gem 'launchy', '~> 2.5'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'selenium-webdriver', '~> 4.26'
  gem 'shoulda-matchers', '~> 5.2'
  gem 'webmock', '~> 3.23'
end

gem 'bootstrap', "~> 5.3"
gem 'bootsnap', require: false
gem 'commonwealth-vlr-engine', github: 'boston-library/commonwealth-vlr-engine', branch: 'blacklight-8'
gem 'cssbundling-rails'

gem 'importmap-rails'
gem 'propshaft'

gem 'puma', '>= 5.0'

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
