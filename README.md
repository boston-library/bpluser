# Bpluser

[![Build Status](https://travis-ci.com/boston-library/bpluser.svg?branch=master)](https://travis-ci.com/boston-library/bpluser) [![Coverage Status](https://coveralls.io/repos/github/boston-library/bpluser/badge.svg?branch=master)](https://coveralls.io/github/boston-library/bpluser?branch=master)

Rails engine for providing Devise-based user models and functionality for digital repository applications using
 [CommonwealthVlrEngine](https://github.com/boston-library/commonwealth-vlr-engine).

This includes bookmarks (Blacklight default), custom folders, and saved searches.

# Requirements
- `ruby >= 2.6.10`
- `rails ~> 6.0.6`
- `postgres v12 or higher`

To install, add the following to your Gemfile:
```ruby
gem 'bpluser', '~> 0.1.0'
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
