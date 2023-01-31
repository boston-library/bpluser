# frozen_string_literal: true

# desc "Explaining what the task does"
# task :bpluser do
#   # Task goes here
# end

# APP_ROOT = File.expand_path("../..", __FILE__)

namespace :bpluser do
  namespace :install do
    desc 'Copy over the updated migrations needed for new version'
    task update_migrations: :environment do
      ENV['MIGRATIONS_PATH'] = 'db/update_migrate'

      if Rake::Task.task_defined?('bpluser:install:migrations')
        Rake::Task['bpluser:install:migrations'].invoke
      else
        Rake::Task['app:bpluser:install:migrations'].invoke
      end
    end
  end

  namespace :test_index do
    desc 'Put sample data into test app solr'
    task seed: :environment do
      require 'yaml'
      docs = YAML.safe_load(File.open(File.join(File.join(Bpluser.root,
                                                          'spec',
                                                          'fixtures',
                                                          'sample_solr_documents.yml'))))
      conn = Blacklight.default_index.connection
      conn.add docs
      conn.commit
    end
  end
end
