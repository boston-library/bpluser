# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: ::User do
    email { 'testy@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
