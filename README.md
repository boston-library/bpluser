# Bpluser

Rails engine for providing Devise-based user models and functionality for digital repository applications using
 [CommonwealthVlrEngine](https://github.com/boston-library/commonwealth-vlr-engine).

This includes bookmarks (Blacklight default), custom folders, and saved searches.

To install, add the following to your Gemfile:
```ruby
gem 'bpluser', git: 'https://github.com/boston-library/bpluser'
```
Then run:
```
$ bundle install
$ rails generate bpluser:install
```

(Note that the installer will ask to overwrite your local `config/locales/devise.en.yml`).
