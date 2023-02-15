# frozen_string_literal: true

FactoryBot.define do
  factory :bpluser_folder, class: 'Bpluser::Folder' do
    association :user, factory: :user
    title { 'Test Title' }
    description { 'Test Description' }
    visibility { Bpluser::Folder::VALID_VISIBILITY_OPTS.sample }
  end
end
