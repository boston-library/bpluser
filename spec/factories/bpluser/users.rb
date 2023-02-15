# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    email { generate(:bpluser_email) }
    password { 'password' }
    password_confirmation { 'password' }
    first_name { 'Test' }
    last_name { 'Testerson' }

    trait :polaris_user do
      provider { 'polaris' }
      uid { '299999999999' }
      email { 'test.testerson@example.com' }
      password { Devise.friendly_token[0, 20] }
      password_confirmation { nil }
      first_name { nil }
      last_name { nil }
    end
  end
end
