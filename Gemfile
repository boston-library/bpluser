# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }
# Declare your gem's dependencies in bpluser.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'bootsnap', require: false
# jquery-rails is used by the dummy application
group :development, :test do
  gem 'bootstrap', '~> 4'
  gem 'commonwealth-vlr-engine', github: 'boston-library/commonwealth-vlr-engine'
  gem 'coveralls', require: false
  gem 'dotenv-rails', '~> 2.8', require: 'dotenv/rails-now'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.1'
  gem 'font-awesome-sass', '~> 5.0'
  gem 'jquery-rails', '~> 4.5'
  gem 'pry', '~> 0.14'
  gem 'puma', '~> 5.6.5'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rubocop', '~> 1.44', require: false
  gem 'rubocop-performance', '~> 1.15', require: false
  gem 'rubocop-rails', '~> 2.17', require: false
  gem 'rubocop-rspec', '~> 2.18', require: false
  gem 'sass-rails', '> 5.0'
  gem 'sprockets', '> 4'
  gem 'sprockets-rails', '~> 3.4'
  gem 'turbolinks', '~> 5'
  gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
end

group :test do
  gem 'capybara', '~> 3.38', '< 4'
  gem 'climate_control', '~> 1.1'
  gem 'coveralls_reborn', '~> 0.26.0', require: false
  gem 'database_cleaner-active_record', '~> 2'
  gem 'launchy', '~> 2.5'
  gem 'selenium-webdriver', '~> 4.11'
  gem 'shoulda-matchers', '~> 5.2'
  gem 'webmock', '~> 3.18'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
