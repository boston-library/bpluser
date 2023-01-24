# frozen_string_literal: true

FactoryBot.define do
  factory :search, class: ::Search do
    association :user, factory: :user
  end
end
