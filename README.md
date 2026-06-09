# Bpluser



+++++++++++++++++++++++++++++++++++++++
Chatgpt rewrites a workable Jenkins bpluser_branch shell script:
https://jenkins.bpl.org/view/Mic/job/bpluser_branch/2657/

+++++++++++++++++++++++++++++++++++++++
name: Rails CI

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: postgres
        ports:
          - 5432:5432
        options: >-
          --health-cmd="pg_isready -U postgres"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=5

    env:
      PGVER: 15
      PGHOST: 127.0.0.1
      PGUSER: postgres
      PGPASSWORD: postgres
      PGPORT: 5432

      LD_PRELOAD: /lib/x86_64-linux-gnu/libjemalloc.so.2
      BUNDLE_GEMFILE: ${{ github.workspace }}/Gemfile

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Determine Ruby version from .travis.yml
        id: ruby-version
        run: |
          RUBY_VER=$(grep -r 'rvm' .travis.yml | cut -d ':' -f2 | xargs)
          echo "ruby_version=$RUBY_VER" >> $GITHUB_OUTPUT
          echo "$RUBY_VER" > .ruby-version

      - name: Determine Rails version
        run: |
          RAILS_VER=$(grep -r 'RAILS_VERSION' .travis.yml | cut -d"=" -f2 | rev | cut -c2- | rev | xargs)
          echo "Rails version: $RAILS_VER"

      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ steps.ruby-version.outputs.ruby_version }}
          bundler-cache: false

      - name: Show versions
        run: |
          ruby --version
          gem --version
          bundler --version

      - name: Remove Gemfile.lock
        run: rm -f Gemfile.lock

      - name: Install Chromium
        run: |
          sudo apt-get update
          sudo apt-get install -y chromium-browser

      - name: Install gems
        run: bundle install --jobs 4 --retry 3

      - name: Start headless Chromium
        run: |
          chromium-browser \
            --headless \
            --disable-gpu \
            --no-sandbox \
            --remote-debugging-port=9222 \
            http://localhost &
          sleep 5

      - name: Prepare database
        run: |
          RAILS_ENV=test bin/rails app:db:drop
          RAILS_ENV=test bin/rails app:db:prepare

      - name: Run CI
        run: |
          RAILS_ENV=test bin/rails ci






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