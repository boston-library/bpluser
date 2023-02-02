# frozen_string_literal: true

FactoryBot.define do
  sequence :bpluser_email do |n|
    Faker::Internet.free_email(name: "Test Testerson #{n}")
  end
end
