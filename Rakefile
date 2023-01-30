# frozen_string_literal: true

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
# load rake tasks defined in lib/tasks that are not loaded in lib/active_fedora.rb
Dir['lib/tasks/*.rake'].each { |rake| load rake }

load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.requires << 'rubocop-rspec'
    task.requires << 'rubocop-performance'
    task.requires << 'rubocop-rails'
    task.fail_on_error = true
  end
rescue LoadError
  task rubocop: :environment do
    warn 'Rubocop is disabled'
  end
end

require 'solr_wrapper'
require 'solr_wrapper/rake_task'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

desc 'Lint, spin up Solr, index test docs, run test suite'
task ci: :environment do
  SolrWrapper.wrap(port: 8984, version: '8.11.2', persist: false) do |solr|
    solr.with_collection(name: 'blacklight-core', dir: 'spec/dummy/solr/conf/') do
      system 'RAILS_ENV=test rake app:bpluser:test_index:seed'
      Rake::Task['spec'].invoke
    end
  end
end

task default: [:spec]
