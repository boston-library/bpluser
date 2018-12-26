begin
  require 'bundler/setup'
  require 'bundler/gem_tasks'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require File.expand_path('../spec/dummy/config/application', __FILE__)
Rails.application.load_tasks
require 'rails/commands'
# load rake tasks defined in lib/tasks that are not loaded in lib/active_fedora.rb
Dir['lib/tasks/*.rake'].each { |rake| load rake }


task :default => [:spec]
