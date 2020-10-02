# Bpluser

Rails engine for providing Devise-based user models and functionality for [CommonwealthVlrEngine](https://github.com
/boston
-library/commonwealth-vlr-engine)-based digital repository applications.

To install, add the following to your Gemfile:
```ruby
gem 'bpluser', git: 'https://github.com/boston-library/bpluser'
```
Then run:
```
$ bundle install
$ rails generate bpluser:install
```

TK more info about what is included in this gem.

To add administrative user functionality: 
1. Add this to `app/models/user.rb`:
```ruby
# Connects this user object to Hydra behaviors.
include Hydra::User
# Connects this user object to Institution-management behaviors.
include Bpl::InstitutionManagement::UserInstitutions
# Connects this user object to Role-management behaviors.
include Hydra::RoleManagement::UserRoles
```
2. Copy `lib/generators/bpluser/templates/models/ability.rb` from this project to your app's `app/models` directory.