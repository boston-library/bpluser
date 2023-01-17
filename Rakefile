# frozen_string_literal: true

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
# load rake tasks defined in lib/tasks that are not loaded in lib/active_fedora.rb
Dir['lib/tasks/*.rake'].each { |rake| load rake }

load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

task default: [:spec]
