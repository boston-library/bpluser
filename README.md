# Bpluser

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