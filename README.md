# Bpluser



+++++++++++++++++++++++++++++++++++++++
I wrote this script but it is failed at 
Run RAILS_ENV=test bundle exec rake
rake aborted!
Don't know how to build task 'default' (See the list of available tasks with `rake --tasks`)
/home/runner/work/bpluser/bpluser/vendor/bundle/ruby/3.4.0/gems/rake-13.4.2/exe/rake:27:in '<top (required)>'
/opt/hostedtoolcache/Ruby/3.4.4/x64/bin/bundle:25:in 'Kernel#load'
/opt/hostedtoolcache/Ruby/3.4.4/x64/bin/bundle:25:in '<main>'
(See full trace by running task with --trace)

+++++++++++++++++++++++++++++++++++++++
name: Build branches

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-22.04

    strategy:
      matrix:
        rails_version: ['7.2.3']


    # Define environment variables globally for the job
    env:
      RAILS_ENV: test
      PGHOST: localhost
      PGUSER: postgres
      PGPASSWORD: postgres
      PGPORT: 5432

    # Services start sidecar containers (Postgres) automatically
    services:
      postgres:
        image: postgres:12
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
        ports:
          - 5432:5432
        # Health check ensures Postgres is ready before the script runs
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5


    steps:
      - uses: browser-actions/setup-chrome@v2
      - run: chrome --version

      - uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.4.4
          bundler-cache: true

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: yarn
          # cache-dependency-path: './spec/internal/yarn.lock'
          cache-dependency-path: './spec/dummy/yarn.lock'

      - name: Install bundle packages
        run: bundle install

      - name: Install yarn packages
        run: yarn install
        # working-directory: ./spec/internal
        working-directory: ./spec/dummy

      - name: Compile yarn CSS
        run: yarn build:css
        # working-directory: ./spec/internal
        working-directory: ./spec/dummy

      - name: Setup Chrome
        uses: browser-actions/setup-chrome@v1
        with:
          chrome-version: stable

      - name: Start Chromium in Headless Mode
        run: |
          chrome --headless --disable-gpu --no-sandbox --remote-debugging-port=9222 http://localhost &
          # Give Chromium a couple of seconds to spin up before next steps
          sleep 3

      # - name: run browsers data update
      #   run: npx update-browserslist-db@latest
      #   working-directory: ./spec/dummy

      - name: Create test database
        run: RAILS_ENV=test bundle exec rails db:test:prepare
        # run: RAILS_ENV=test bundle exec rails app:db:prepare
        # working-directory: ./spec/internal
        working-directory: ./spec/dummy

      - name: Run linter and tests
        run: RAILS_ENV=test bundle exec rake
        working-directory: ./spec/dummy








+++++++++++++++++++++++++++++++++++++++









[![Build Status](https://travis-ci.com/boston-library/bpluser.svg?branch=master)](https://travis-ci.com/boston-library/bpluser) [![Coverage Status](https://coveralls.io/repos/github/boston-library/bpluser/badge.svg?branch=master)](https://coveralls.io/github/boston-library/bpluser?branch=master)

Rails engine for providing Devise-based user models and functionality for digital repository applications using
 [CommonwealthVlrEngine](https://github.com/boston-library/commonwealth-vlr-engine).

This includes bookmarks (Blacklight default), custom folders, and saved searches.

# Requirements
- `ruby >= 3.1, < 3.2`
- `rails ~> 6.1.7`
- `postgres v12 or higher`

To install, add the following to your Gemfile:
```ruby
gem 'bpluser', '~> 0.5.0'
# OR
gem 'bpluser', git: 'https://github.com/boston-library/bpluser'
```
Then run:
```
$ bundle install
$ rails generate bpluser:install
```

When updating run

```
rails bpluser:install:update_migrations
```

(Note that the installer will ask to overwrite your local `config/locales/devise.en.yml`).

### Local development

In one console, start Solr from project root:
```
$ solr_wrapper --config .solr_wrapper.yml 
```
In a second console, index the sample Solr documents (run from `./spec/dummy`):
```
# Solr must be running
$ bundle exec rake bpluser:test_index:seed
```
Run the migrations and start the app (in second console, run from `./spec/dummy`):
```
bundle exec rake db:create
bundle exec rake db:migrate
rails s
# app should be accessible at 127.0.0.1:3000
```

### Running tests

Start Solr from project root:
```
$ solr_wrapper --config .solr_wrapper_test.yml 
```
Index the sample Solr documents (run from `./spec/dummy`):
```
# Solr must be running
$ RAILS_ENV=test bundle exec rake bpluser:test_index:seed
```
Run specs
```
# run all tests
$ bundle exec rake spec

# run a single spec
$ bundle exec rake spec SPEC=./spec/models/some_model_spec.rb
```