source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }
# Declare your gem's dependencies in bpluser.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'omniauth-polaris', github: 'boston-library/omniauth-polaris', branch: 'update-5.2', require: false
gem 'bootsnap', require: false
# jquery-rails is used by the dummy application
group :development, :test do
  gem "jquery-rails"
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
